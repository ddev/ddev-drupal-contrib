[![tests](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# DDEV Drupal Contrib

DDEV integration for developing Drupal contrib projects. As a general philosophy, your contributed module is the center of the universe. The codebase layout (see image below) and commands in this project [match the Gitlab CI approach](https://git.drupalcode.org/project/gitlab_templates) from the Drupal Association.


## Install

1. If you haven't already, [install Docker and DDEV](https://ddev.readthedocs.io/en/latest/users/install/)
2. `git clone` your contrib module
3. cd [contrib module directory]
4. Configure DDEV for Drupal using `ddev config --project-type=drupal --docroot=web --php-version=8.3 --project-name=[module]` or select these options when prompted using `ddev config`
   - Remove underscores in the project name, or replace with hyphens. (DDEV will do this for you in v1.23.5+)
   - See [Misc](#misc) for help on using alternate versions of Drupal core.
5. Run `ddev get ddev/ddev-drupal-contrib`
6. Run `ddev quickstart`

## Update

Update by running the `ddev get ddev/ddev-drupal-contrib` command.

## Commands

This project provides the following DDEV host commands.

- [ddev quickstart](commands/host/quickstart)
  - Runs all necessary commands to get you up and running.

This project provides the following DDEV container commands.

- [ddev poser](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/poser).
  - Creates a temporary [composer.contrib.json](https://getcomposer.org/doc/03-cli.md#composer) so that `drupal/core-recommended` becomes a dev dependency. This way the composer.json from the module is untouched.
  - Runs `composer install` AND `yarn install` so that dependencies are available.
  - Note: it is perfectly acceptable to skip this command and edit the require-dev of composer.json by hand.
- [ddev symlink-project](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/symlink-project). Symlinks the top level files of your project into web/modules/custom so that Drupal finds your module. This command runs automatically on every `ddev start` _as long as Composer has generated `vendor/autoload.php`_ which occurs during `composer install/update`. See codebase image below.

Run tests on the `web/modules/custom` directory:

- `ddev phpunit` Run [PHPUnit](https://github.com/sebastianbergmann/phpunit) tests.
- `ddev nightwatch` Run Nightwatch tests, requires [DDEV Selenium Standalone Chrome](https://github.com/ddev/ddev-selenium-standalone-chrome).
- `ddev phpcs` Run [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer).
- `ddev phpcbf` Fix phpcs findings.
- `ddev phpstan`. Run [phpstan](https://phpstan.org) on the web/modules/custom directory.
- `ddev eslint` Run [ESLint](https://github.com/eslint/eslint) on JavaScript files.
- `ddev stylelint` Run [Stylelint](https://github.com/stylelint/stylelint) on CSS files.


## Codebase layout

![Folder tree](/assets/folders.png)


## Misc

- Optional: [Install the ddev-selenium-standalone-chrome extension for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Optional: [Install the ddev-mkdocs extension for local preview of your docs site](https://github.com/nireneko/ddev-mkdocs). Drupal.org's Gitlab CI can [automatically publish your site](https://project.pages.drupalcode.org/gitlab_templates/jobs/pages/).
- Optional. Commit the changes in the `.ddev` folder after this plugin installs. This saves other users from having to install this integration.
- If you add/remove a root file or directory, re-symlink root files via EITHER of these methods
  - `ddev restart`
  - `ddev symlink-project`
- `cweagans/composer-patches:^1` is added by `ddev poser` so feel free to configure any patches that your project needs.
- Any development dependencies (e.g. Drush) should be manually added to require-dev in your project's composer.json file. Don't use the `composer require` command to do that.

### Changing the Drupal core version

- To customize the version of Drupal core, create a `.ddev/config.local.yaml` (or [any filename lexicographically following config.contrib.yaml](https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#extending-configyaml-with-custom-configyaml-files)) with contents similar to
```
web_environment:
  - DRUPAL_CORE=^11
```

After creating this file, run `ddev restart` and then `ddev poser` to update the Drupal core version.

If Drupal core cannot be changed because the project is using an unsupported version of PHP, `ddev poser` will show a `composer` error. In that case, open `.ddev/config.yaml` and change the `PHP_VERSION` to a supported version; then run `ddev restart` and `ddev poser` again.  Note that the project PHP version is set in `.ddev/config.yaml`, while the core version to use is set in `.ddev/config.local.yaml`. 

## Example of successful test

This is what a successful test looks like, based on [Config Enforce Devel](https://www.drupal.org/project/config_enforce_devel).

```
user:~/config_enforce_devel$ ddev phpunit
PHPUnit 9.6.15 by Sebastian Bergmann and contributors.

Default Target Module (Drupal\Tests\config_enforce_devel\Functional\DefaultTargetModule)
 ✔ Default target module created

Form Alter Implementation Order (Drupal\Tests\config_enforce_devel\Functional\FormAlterImplementationOrder)
 ✔ Form alter implementation order

Theme Settings Form (Drupal\Tests\config_enforce_devel\Functional\ThemeSettingsForm)
 ✔ Theme settings form submit

Time: 00:13.453, Memory: 4.00 MB

OK (3 tests, 20 assertions)
```

## Automatically correct coding standard violations

You can set up a pre-commit hook that runs phpcbf:
1. Create a new file `touch .git/hooks/pre-commit` in your repository if it doesn't already exist.
2. Add the following lines to the `pre-commit` file:

```bash
#!/bin/bash

ddev phpcbf -q
```

3. Mark the file as executable: `chmod +x pre-commit`.

## Add-on tests

Tests are done with Bats. It is a testing framework that uses Bash. 

To run tests locally you need to first install bats' git submodules with: 

```sh
git submodule update --init
```

Then you can run within the root of this project:

```sh
./tests/bats/bin/bats ./tests
```

Tests will be run using the default drupal core of the contrib. To test against a different Drupal core version, update the `TEST_DRUPAL_CORE` environment 
variable.

i.e. `TEST_DRUPAL_CORE=11 ./tests/bats/bin/bats ./tests`.

Tests are triggered automatically on every push to the 
repository, and periodically each night. The automated tests are agains all of
the supported Drupal core versions.

Please make sure to attend to test failures when they happen. Others will be 
depending on you. 

Also, consider adding tests to test for bugs or new features on your PR.

To learn more about Bats see the [documentation][bats-docs].

[bats-docs]: https://bats-core.readthedocs.io/en/stable/

## Troubleshooting

"Error: unknown command":

The commands from this addon are available when the project type is `drupal`. Make sure the `type` configuration is correctly set in `.ddev/config.yaml`:

```yaml
type: drupal
```

Don't forget to run `ddev restart` if `.ddev/config.yaml` has been updated.

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**
