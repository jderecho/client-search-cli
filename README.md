# Client Operation CLI

A minimalist command-line application to search clients by name and detect duplicate emails in a dataset.

### Requirements
- Ruby (>= 2.7)
- Bundler gem

### Installation
1. Clone the repository:
   ```sh
    git clone git@github.com:jderecho/client-search-cli.git
    cd client-search-cli
   ```

2. Install dependencies using Bundler:
   ```sh
    gem install bundler
    bundle install
   ```

### Usage
Run the script with the following commands:

Search through all clients and return those with names partially matching a given search query

```sh
syntax: ruby app.rb search FIELD SEARCH_TERM

e.g.
ruby app.rb search full_name jane

minimalist version
./bin/search jane 
```

Find out if there are any clients with the same email in the dataset, and show those duplicates if any are found.

```sh
syntax: ruby app.rb find_duplicates FIELD

e.g.
ruby app.rb find_duplicates email

minimalist version
./bin/find_duplicates
```

### Running Tests
To run RSpec tests, use:
```sh
  rspec .
```

### Assumptions
- The command-line arguments can be passed and the syntax differs between cli operations, see Usage section.
- We want to print the error message if it occurs during the cli operations.
- The `find_duplicates` action returns all duplicates in a hash in these format:
  ```
    { "duplicated_value" : [duplicated_hashes] }
  ```
- Assumes that the return value is an empty hash when no duplicates are found during the `find_duplicates` operation.
- Assumes that during a search operation, the search term can be a string or number.
- The search operation is performed in a case-insensitive manner.
- Assumes that the client hash contains known and static keys. I've added a validation to ensure the keys are recognized and valid.
- Assumes all command-line actions other than search and find_duplicates are invalid.


### Added Features
- Autoloading with Zeitwerk: I used the Zeitwerk gem to efficiently autoload files within the lib folder
- GitHub Actions Implementation: I configured GitHub Actions to automate workflows, specifically to run RSpec tests
- Command Handling: I used the Thor gem to manage and define command-line syntax, making it easier to structure and execute commands in the application.

### Known Limitation
- Only files with .json extension with valid JSON format will be used. Validations are in place to ensure the files are both valid and existing.
- The search command only supports partial matching for string fields and exact matching for integer fields.
- The client hash is restricted to just (id, full_name, and email) keys.
- Any JSON file hosted externally and accessible via URL cannot be handled.

### How you would enhance or refactor the architecture
- Database Implementation: The choice depends on the expected data size, number of users, and the need for flexibility. I would likely choose PostgreSQL, MongoDB, or SQLite based on those factors.
- Model & Database Connection: Depending on the chosen database, I would leverage existing gems such as Sequel, ActiveRecord, or ROM-RB to handle the connection and data modeling.
- If I have more time, I would move both the validation and the logic from the command classes (search, find_duplicate) into a single action service class.


### Features or improvements you would prioritize next
- Allow an option to import json files from a remote source.
- Handle the importation of json data to a database and implement model and database connection.
- Expose RESTful endpoints using a lightweight framework like Sinatra
- Add Logging capability
