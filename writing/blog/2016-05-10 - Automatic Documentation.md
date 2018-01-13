# Automatic Documentation

The technological trend in recent times is to store the user’s information in the cloud so that they can access it from any mobile, wearable or desktop device. To achieve this, you need to have some kind of API hosted on a server that feeds the apps, on this post we are going to focus on REST API. This way, we are able to have the business logic and data on the server side.

At Wolox, we provide technological solutions to startups. We usually build web and mobile platforms for our clients using technologies such as Angular, Android, and iOS, and we use Ruby on Rails for the backend API. As you can imagine, for a project requiring all these technologies, several specialized teams are needed in order to provide the best possible service. This workflow creates a **strong and inevitable dependence between the API and the rest of the technologies**. Any change made to the API is automatically reflected on the devices. If the team is working on the first version of the API (or if it doesn’t have versioning) and these changes are important, they may even cause the apps to stop working or have errors that affect usability. While it is true that the contract that provides the API should not change, there are situations that make these changes unavoidable, and thus, **communication between the teams is essential**.

One of the best ways the API team can communicate with the other teams is through the endpoints **documentation**. It is useful both for the rest of the development teams and for potential external consumers. It is also practical for the API development team itself as it saves a lot of time spent answering questions about each of the resources presented.

All developers have suffered at one point due to poor documentation. What defines poor documentation? Mainly, it’s the lack of updates and clarity on how the service should be used. How many times have we seen documentation that does not detail the headers required for the request? Or that showed a sample response that does not match reality? Or other cases in which the documented endpoint no longer exists or has changed its path?

The only ones responsible for this are the API developers themselves who, although aware that it is necessary to have good documentation, also know that this task is **tedious** and **time-consuming**. So, good documentation is something difficult to have when you’re under pressure due to client’s deadlines and the speed of the market. Therefore, documenting is often a process that is not prioritized and even if it is, it is very likely that it will become **deprecated** quickly. Consequently, it’s delayed or made quickly (almost like a rough draft of some sort), while other features of the system are on the focus.

Many tools have emerged over time to simplify the task. [Apiary](https://apiary.io/), for example, allows making a mock of all endpoints and their responses, giving the option for the mobile applications to consume these fake resources without having to deploy them to the real API. It is very useful because app development is not delayed if the API team is having trouble delivering on time, and can also be used as documentation because you can add descriptions to the endpoints, clearly showing the way it is used and the response received.

However, since the data is mocked, any changes made in the implementation must be quickly changed in the documentation so as to keep it updated. The biggest problem this has is that some changes, such as a serializer change, are replicated in many endpoints. It may even be that the developer itself is **not aware of the extent** of this change if they are working with a fairly large API, so, although this tool has many advantages, it is very susceptible to obsolescence.

There are other tools that require the API developers to write extra code (usually some sort of comment) above the method that they want to document. You usually list its description, parameters, response example and sometimes more. This is the traditional way to document in languages such as Java. These tools create beautiful HTML documents, but have certain disadvantages: if the method response can be defined, developers must keep the information updated, not to mention that the API could return a very large JSON or XML, causing the controller to have many lines of comments and/or code for documentation. All those lines added makes the code more complex and harder to read. The documentation can even be longer than the code itself!

Tools that try to shed some light into this issue are starting to appear. These are the ones that generate documentation through the tests. A robust and good quality API **MUST have tests**, and such tests should cover most common use cases (at least). That’s why the information used for these tests may be helpful in understanding the operation of the API and would be very useful to be able to extract it **automatically**. So, addressing the problem this way, we can have all the information updated every time the tests are run! And furthermore, we are **forced to have a good amount of API use case tests**. A WIN-WIN situation. The tools used when applying this methodology have a small disadvantage: They create a kind of DSL to be able to use it, increasing the developer’s learning curve.

That’s why I decided to create Dictum, a tool with these characteristics for Rails that is **easy** to use and **powerful** enough to let you **customize** it any way you want!

So far, it creates documentation in markdown and HTML formats. Let’s see a short example similar to how we use it in Wolox:

First you have to add the configuration file:
```ruby
# /config/initializers/dictum.rb
Dictum.configure do |config|
  config.output_path = Rails.root.join('docs')
  config.root_path = Rails.root
  config.output_filename = 'Documentation'
  config.output_format = :markdown
end
```

Then you can customize your Rspec’s after(:each) hook like this:
```ruby
# spec/support/spec_helper.rb
RSpec.configure do |config|
  config.after(:each) do |test|
    if test.metadata[:dictum]
      Dictum.endpoint(
        resource: test.metadata[:described_class].to_s.gsub('Controller', ''),
        endpoint: request.fullpath,
        http_verb: request.env['REQUEST_METHOD'],
        description: test.metadata[:dictum_description],
        request_body_parameters: request.env['action_dispatch.request.parameters'],
        response_status: response.status,
        response_body: response.body
      )
    end
  end
end
```

After that, tell Dictum which tests are you going to document:
```ruby
# spec/controllers/my_resource_controller_spec.rb
require 'spec_helper'

describe MyResourceController do
  Dictum.resource(name: 'MyResource', description: 'This is MyResource description.')

  describe '#some_method' do
    context 'some context of my resource' do

      it 'returns status ok', dictum: true, dictum_description: 'Some description of the endpoint.' do
        get :index
        expect(response_status).to eq(200)
      end

    end
  end
end
```

And finally run: bundle exec rake dictum:document

That was really simple wasn’t it? You can read the gem’s [README](https://github.com/Wolox/dictum/blob/master/README.md) if you need more information.

The gem is in a very early stage and has a long way to go, so feel free to report issues or make pull requests if you liked it!
