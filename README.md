[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-drupal-contrib)](https://github.com/ddev/ddev-drupal-contrib/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-drupal-contrib)](https://github.com/ddev/ddev-drupal-contrib/releases/latest)

# DDEV Drupal Contrib

DDEV integration for developing Drupal contrib projects. As a general philosophy, your contributed module/theme is the center of the universe. The codebase layout (see image below) and commands in this project [match the Gitlab CI approach](https://git.drupalcode.org/project/gitlab_templates) from the Drupal Association.


## Install

1. If you haven't already, [install Docker and DDEV](https://ddev.readthedocs.io/en/latest/users/install/)
2. `git clone` your contrib module
3. cd [contrib module directory]
4. Configure DDEV for Drupal using `ddev config --project-type=drupal --docroot=web --php-version=8.3 --corepack-enable --project-name=[module]` or select these options when prompted using `ddev config`
   - Remove underscores in the project name, or replace with hyphens. (DDEV will do this for you.)
   - See [Misc](#misc) for help on using alternate versions of Drupal core.
5. Run `ddev add-on get ddev/ddev-selenium-standalone-chrome && ddev add-on get ddev/ddev-drupal-contrib`
6. Run `ddev start`
7. Run `ddev poser`
8. Run `ddev symlink-project`
9. `ddev config --update` to detect expected Drupal and PHP versions.
10. `ddev restart`

After installation, make sure to commit the `.ddev` directory to version control.

## Update

```bash
ddev add-on get ddev/ddev-selenium-standalone-chrome
ddev add-on get ddev/ddev-drupal-contrib
ddev restart
```

## Commands

This project provides the following DDEV container commands.

- [ddev poser](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/poser).
  - Creates a temporary [composer.contrib.json](https://getcomposer.org/doc/03-cli.md#composer) so that `drupal/core-recommended` becomes a dev dependency. This way the composer.json from the module is untouched.
  - Runs `composer install` AND `yarn install` so that dependencies are available. Additional arguments to `ddev poser` like --prefer-source are passed along to `composer install`
  - Note: it is perfectly acceptable to skip this command and edit the require-dev of composer.json by hand.
- [ddev symlink-project](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/symlink-project). Symlinks your project files into the configured location (defaults to `web/modules/custom`) so Drupal can find your module. This command runs automatically on every `ddev start` _as long as Composer has generated `vendor/autoload.php`_ which occurs during `composer install/update`. See codebase image below.

Run tests on your project code (defaults to `web/modules/custom`, [configurable](#changing-the-symlink-location)):

- `ddev phpunit` Run [PHPUnit](https://github.com/sebastianbergmann/phpunit) tests.
- `ddev nightwatch` Run Nightwatch tests, requires [DDEV Selenium Standalone Chrome](https://github.com/ddev/ddev-selenium-standalone-chrome).
- `ddev phpcs` Run [PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer).
- `ddev phpcbf` Fix phpcs findings.
- `ddev phpstan`. Run [phpstan](https://phpstan.org) on project files.
- `ddev eslint` Run [ESLint](https://github.com/eslint/eslint) on JavaScript files.
- `ddev stylelint` Run [Stylelint](https://github.com/stylelint/stylelint) on CSS files.


## Codebase layout

![Folder tree](/assets/folders.png)


## Misc

- The [ddev-selenium-standalone-chrome add-on helps run FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome). This add-on already depends on that one so you likely have it installed.
- Optional: [Install the ddev-mkdocs extension for local preview of your docs site](https://github.com/nireneko/ddev-mkdocs). Drupal.org's Gitlab CI can [automatically publish your site](https://project.pages.drupalcode.org/gitlab_templates/jobs/pages/).
- Optional. Commit the changes in the `.ddev` folder after this plugin installs. This saves other users from having to install this integration.
- If you add/remove a root file or directory, re-symlink root files via EITHER of these methods
  - `ddev restart`
  - `ddev symlink-project`
- `cweagans/composer-patches:^1` is added by `ddev poser` so feel free to configure any patches that your project needs.
- Any development dependencies (e.g. Drush) should be manually added to require-dev in your project's composer.json file. Don't use the `composer require` command to do that.

## Changing defaults

Override any environment variable value from [.ddev/config.contrib.yaml](config.contrib.yaml) by creating a `.ddev/config.local.yaml` (or [any filename lexicographically following config.contrib.yaml](https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#extending-configyaml-with-custom-configyaml-files)) file which has the same structure as [.ddev/config.contrib.yaml](config.contrib.yaml). Add your overrides under `web_environment`.

### Changing the Drupal core version

In `.ddev/config.local.yaml` set the Drupal core version:

```yaml
web_environment:
  - DRUPAL_CORE=^11
```

Then run `ddev restart` and then `ddev poser` to update the Drupal core version.

If Drupal core cannot be changed because the project is using an unsupported version of PHP, `ddev poser` will show a `composer` error. In that case, open `.ddev/config.yaml` and change the `PHP_VERSION` to a supported version; then run `ddev restart` and `ddev poser` again.  Note that the project PHP version is set in `.ddev/config.yaml`, while the core version to use is set in `.ddev/config.local.yaml`.

### Changing the symlink location

In `.ddev/config.local.yaml` set the location relative to webroot (which usually is `web/`). Defaults to `modules/custom`

```yaml
web_environment:
  - ...
  - DRUPAL_PROJECTS_PATH=modules/custom
```

Then run `ddev restart` to update the symlink location.

To use with Drupal themes, set `DRUPAL_PROJECTS_PATH=themes/custom` in your config.local.yaml.

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
#!/usr/bin/env bash

ddev phpcbf -q
```

3. Mark the file as executable: `chmod +x pre-commit`.

## Troubleshooting

"Error: unknown command":

The commands from this addon are available when the project type is `drupal`. Make sure the `type` configuration is correctly set in `.ddev/config.yaml`:

```yaml
type: drupal
```

> [!TIP]
> Remember to run `ddev restart` if `.ddev/config.yaml` has been updated.

## Contributing

Tests are done with Bats. It is a testing framework that uses Bash. To run tests locally you need to first install bats' git submodules with:

```bash
git submodule update --init
```

Then you can run within the root of this project:

```bash
./tests/bats/bin/bats ./tests
```

Tests will be run using the default drupal core of the contrib. To test against a different Drupal core version, update the `TEST_DRUPAL_CORE` environment
variable.

i.e. `TEST_DRUPAL_CORE=11 ./tests/bats/bin/bats ./tests`.

Tests are triggered automatically on every push to the
repository, and periodically each night. The automated tests are against all the supported Drupal core versions.

Also, consider adding tests in your PR.

To learn more about Bats, see the [documentation][bats-docs].

[bats-docs]: https://bats-core.readthedocs.io/en/stable/

## Credits

Contributed and maintained by Moshe Weitzman ([@weitzman](https://github.com/weitzman)) and 
Dezső BICZÓ  ([@mxr576](https://github.com/mxr576))
