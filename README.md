[![tests](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-drupal-contrib/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2025.svg)

# DDEV Drupal Contrib

DDEV integration for developing Drupal contrib projects. As a general philosophy, your contributed module is the center of the universe. The codebase layout (see image below) and commands in this project [match the Gitlab CI approach](https://git.drupalcode.org/project/gitlab_templates) from the Drupal Association.


## Install

1. If you haven't already, [install Docker and DDEV](https://ddev.readthedocs.io/en/latest/users/install/)
2. `git clone` your contrib module
3. cd [contrib module directory]
4. Configure DDEV for Drupal 10 using `ddev config --project-name=[contrib module] --project-type=drupal10 --docroot=web --create-docroot --php-version=8.1` or select these options when prompted using `ddev config`
   - Remove underscores in the project name, or replace with hyphens.
5. Run `ddev get ddev/ddev-drupal-contrib`
6. Run `ddev start`
7. Run `ddev poser`
8. Run `ddev symlink-project`

## Update

Update by running the `ddev get ddev/ddev-drupal-contrib` command.

## Commands

This project provides the following DDEV container commands.

- [ddev poser](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/poser).
  - Creates a temporary [composer.contrib.json](https://getcomposer.org/doc/03-cli.md#composer) so that `drupal/core-recommended` becomes a dev dependency. This way the composer.json from the module is untouched.
  - Runs `composer install` AND `yarn install` so that dependencies are available.
  - Note: it is perfectly acceptable to skip this command and edit the require-dev of composer.json by hand.
- [ddev symlink-project](https://github.com/ddev/ddev-drupal-contrib/blob/main/commands/web/symlink-project). This symlinks the top level files of your project into web/modules/custom so that Drupal finds your module. This command runs automatically on every `ddev start`. See codebase image below.

Run tests on the `web/modules/custom` directory:

- `ddev phpunit` Run [PHPUnit](https://github.com/sebastianbergmann/phpunit) tests.
- `ddev nightwatch` Run Nightwatch tests, requires [DDEV Selenium Standalone Chrome](https://github.com/ddev/ddev-selenium-standalone-chrome).
- `ddev phpcs` Run [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer/tree/master).
- `ddev phpcbf` Fix phpcs findings.
- `ddev eslint` Run [ESLint](https://github.com/eslint/eslint) on JavaScript files.
- `ddev stylelint` Run [Stylelint](https://github.com/stylelint/stylelint) on CSS files.


## Codebase layout

![Folder tree](/assets/folders.png)


## Misc

- Optional: [Install the ddev-selenium-standalone-chrome extension for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Optional: [Install the ddev-mkdocs extension for local preview of your docs site](https://github.com/nireneko/ddev-mkdocs). Drupal.org's Gitlab CI can [automatically publish your site](https://project.pages.drupalcode.org/gitlab_templates/jobs/pages/).
- Optional. Commit the changes in the `.ddev` folder after this plugin installs. This saves other users from having to install this integration.
- This project reads your `project_type` from DDEV and fetches adds the corresponding version of `drupal/core-recommended` to `composer.json`. if you are doing something non-standard with project_type, don't use `ddev poser` command.
- This project should work for any contrib project, including those that haven't [opted into Gitlab CI](https://www.drupal.org/project/infrastructure/issues/3261803). One advantage of that is that failures in CI are more likely to be reproducible locally when using this integration.
- If you add/remove a root file or directory, re-symlink root files via EITHER of these methods
  - `ddev restart`
  - `ddev symlink-project`
- `cweagans/composer-patches:^1` is added by `ddev poser` so feel free to configure any patches that your project needs.


## Example of succesful test

This is what a succesful test looks like, based on [Config Enforce Devel](https://www.drupal.org/project/config_enforce_devel).

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

## Troubleshooting

"Error: unknown command":

The commands from this addon are available when the project type a valid `drupal` type.
Below, is an example `.ddev/config.yaml` for a Drupal 10 project.

```yaml
type: drupal10
```

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**
