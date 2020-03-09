---
title: Implement a simple AWS S3 multi-file downloader in Ruby
published: true
description: Simple implementation of a multi-file downloader using Ruby backed by AWS S3
tags: aws, s3, ruby, rails
layout: post_with_donation
date: 2020-03-09 00:00:00 -0300
categories: aws s3 ruby rails webdev
---

Recently, I was requested to implement a multi-file download feature like Google drive's. If you use AWS S3 like me, you know that there isn't a direct way to do this, so in this post I'll show you a reference implementation for that.

We are going to need a few dependencies in our project:

```ruby
# Gemfile
gem 'aws-sdk-s3', '~> 1.17'
gem 'rubyzip', '~> 2.2'
```

This post assumes you know how to configure your AWS credentials.

Now let's get to the code! The goal here is to create a zip file which has all our desired files so we can send it to our users. The first thing to do is to download the files, with the official SDK this is quite simple:

```ruby
@filepaths = @s3_keys.map do |key|
  new_path = "#{@dir}/#{key.split('/').last}" # Keep the filename but avoid the fill path
  # This should go in a separate service
  Aws::S3::Resource.new.bucket(@bucket).object(key).download_file(new_path)
  new_path
end
```

Now that we have the files in the machine, lets create a zip with all of them. Following the [rubyzip's documentation](https://github.com/rubyzip/rubyzip#basic-zip-archive-creation), we can do create the zipped file like this:

```ruby
Zip::File.open('Archive.zip', Zip::File::CREATE) do |zipfile|
  @filepaths.each do |filepath|
    zipfile.add(filepath.split('/').last, filepath)
  end
end
```

These simple steps will create our desired zip file! Now we need to put the file somewhere our users can access them. In my case I upload the zip in S3 and create a presigned url for it, but you can change this to fit your needs:

```ruby
object = Aws::S3::Resource.new.bucket(@bucket).object('Archive.zip')
object.upload_file('Archive.zip')

download_url = object.presigned_url(:get)
```

Now that you get the idea, let me join everything to get this code working:

It's better to have a class that hides the S3 related code as much as possible:

```ruby
# s3_service.rb
require 'aws-sdk-s3' # This is not needed in Rails

module S3Service
  class << self
    def upload_file(from:, to:, bucket:)
      object = object(to, bucket: bucket)
      object.upload_file(from)
      object.presigned_url(:get)
    end

    def download_file(key:, to:, bucket:)
      object = object(key, bucket: bucket)
      object.download_file(to)
    end

    def get_download_link(file_name, bucket:)
      object(file_name, bucket: bucket).presigned_url(:get).to_s
    end

    private

    def object(file_name, bucket:)
      bucket(bucket).object(file_name)
    end

    def bucket(bucket)
      Aws::S3::Resource.new.bucket(bucket)
    end
  end
end
```

Now we are ready to build another class that handles the download, zip and upload of the zipped file:

```ruby
# multi_file_zipper_download.rb
require 'zip'

class MultiFileZipperDownload
  ZIPPED_FILE_NAME = 'Archive.zip' # Same as Google drive :P

  def initialize(s3_keys, bucket)
    @s3_keys = s3_keys
    @bucket = bucket
  end

  def call
    zip_files(download_objects)
    build_zipped_s3_key
    upload_zip
    delete_tmp_file
    @zipped_s3_key
  end

  private

  def download_objects
    @s3_keys.map.each_with_index do |key, idx|
      # Avoid replacing files with same name by using the index, you can skip this if you like
      new_path = "#{tmp_dir}/#{idx} - #{key.split('/').last}"
      S3Service.download_file(key: key, to: new_path, bucket: @bucket)
      new_path
    end
  end

  def zip_files(files)
    ::Zip::File.open(zipped_file_path, Zip::File::CREATE) do |zipfile|
      files.each do |filepath|
        zipfile.add(filepath.split('/').last, filepath)
      end
    end
  end

  def tmp_dir
    @tmp_dir ||= Dir.mktmpdir
  end

  def zipped_file_path
    "#{tmp_dir}/#{ZIPPED_FILE_NAME}"
  end

  def build_zipped_s3_key
    # I use the hash of the file to avoid collisions, but you can change this to whatever you like
    hash = Digest::SHA256.file(zipped_file_path).to_s

    @zipped_s3_key = "multi_downloads/#{hash}/#{ZIPPED_FILE_NAME}"
  end

  def upload_zip
    # I upload the zipped file to S3 so we can send a link to tje file afterwards
    S3Service.upload_file(from: zipped_file_path, to: @zipped_s3_key, bucket: @bucket)
  end

  def delete_tmp_file
    # Remove all the files to avoid disk usage leaks
    FileUtils.rm_rf(tmp_dir)
  end
end
```

In order to use this class you can create a simple Sinatra server to test it:

```ruby
# app.rb
require 'sinatra'
require 'json'

# Here you can initialize the AWS config, use ENV variables or any other valid configuration method

require_relative 's3_service'
require_relative 'multi_file_zipper_download'

BUCKET = 'my-bucket'

get '/keys' do
  # Here you can send the list of available s3 keys using your desired storage
end

post '/download' do
  # Get the keys from the JSON body
  params = JSON.parse(request.body.read)

  zipped_key = MultiFileZipperDownload.new(params['keys'], BUCKET).call
  url = S3Service.get_download_link(zipped_key, bucket: BUCKET)

  [200, { url: url }.to_json]
end
```

This code will get you going with this feature, but you need to consider that downloading and uploading files from S3 will block your Ruby's server, so you should run this code in background. I'll leave that as an exercise for the reader.
