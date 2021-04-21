CSV.foreach(
          document,
          headers: parser.csv_has_header, col_sep: separator, header_converters: header_lambda,
          encoding: parser.file_encoding, skip_lines: parser.csv_skip_lines
        ).lazy.map(&csv_block)
