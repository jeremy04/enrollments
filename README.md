Installing:

    gem install bundler
    
    bundle install

    rbenv install (if Ruby 2.2.3 not already installed) 
    rbenv rehash
       or
    rvm install 2.2.3
    rvm gemset create instructure_code_sample
    rvm use 2.2.3@instructure_code_sample
    
    (whew thats alot of steps!)
    
    rake db:schema:load
    
    rake csv_importer:import_all
    
    rspec spec
    
    rails s

Shortcomings:

- SQLite3 has no enums, or foreign key constraints that work with Rail's adapters
- CSV file is loaded entirely into memory, not efficient.
- Wanted to keep it simple, so I didn't add CSS or tables or divs. My motto is make it work before you make it pretty.

