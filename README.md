# Client Search CLI

A minimalist command-line application to search clients by name and detect duplicate emails in a dataset.

## Requirements
- Ruby (>= 2.7)
- Bundler gem

## Installation
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

## Usage
Run the script with the following commands:

- Search through all clients and return those with names partially matching a given search query
```sh
  ruby client_search.rb clients.json search full_name "Jane"
```

- Find out if there are any clients with the same email in the dataset, and show those duplicates if any are found.
```sh
  ruby client_search.rb clients.json duplicates email
```

## Running Tests
To run RSpec tests, use:
```sh
rspec client_search_spec.rb
```

## Assumptions
- Assuming your local device has an SSH access to public github repositories
- Assuming that clients.json or any future JSON files are stored locally.
- The CLI expects valid JSON input; malformed JSON files will not be handled explicitly.