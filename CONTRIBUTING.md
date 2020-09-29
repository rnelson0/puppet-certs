This module has grown over time based on a range of contributions from
people using it. If you follow these contributing guidelines your patch
will likely make it into a release a little quicker.

## Contributing

1. Fork the repo.

2. Run the tests. We only take pull requests with passing tests, and
   it's great to know that you have a clean slate.

3. Add a test for your change. Only refactoring and documentation
   changes require no new tests. If you are adding functionality
   or fixing a bug, please add a test.

4. Make the test pass.

5. Push to your fork and submit a pull request.

## Dependencies

This module is developed using PDK, and all dependencies are managed by
[Bundler](http://bundler.io/) provided through PDK according to the [best
practices](https://puppet.com/docs/pdk/1.x/pdk_testing.html).

By default the tests use a baseline version of Puppet.

If you have Ruby 2.x or want a specific version of Puppet,
you must set an environment variable such as:

    export PUPPET_VERSION="~> 3.2.0"

Install the dependencies like so...

    pdk bundle install

## Syntax and style

You can test style and syntax of your module using PDK.  This will run tests
against your manifests, templates, metadata, and spec tests using rubocop,
[Puppet Lint](http://puppet-lint.com/) and [Puppet Syntax](https://github.com/gds-operations/puppet-syntax).

    pdk validate

If any issues are found, the PDK can perform auto-corrections with the `-a` flag

    pdk validate -a

## Running the unit tests

The unit test suite covers most of the code, as mentioned above please
add tests if you're adding new functionality. If you've not used
[rspec-puppet](http://rspec-puppet.com/) before then feel free to ask
about how best to test your new feature. Running the test suite is done
with:

    pdk test unit
