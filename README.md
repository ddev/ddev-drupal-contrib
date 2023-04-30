DDEV integration for developing Drupal contrib projects. This project reuses the code and approach from the [Drupal Association's Gitlab CI workflow](https://git.drupalcode.org/project/gitlab_templates/). It should work for any contrib project, including those that havent [opted into Gitlab CI](https://www.drupal.org/project/infrastructure/issues/3261803). One great advantage of that is that failures in CI are more likely to be reproducible locally when using this integration.

As a general philosophy, Your contributed module is the center of the universe. It lives at the root of your codebase.

Usage
============
- Git clone your project from drupal.org. 
- [Add DDEV to your contrib project](https://ddev.readthedocs.io/en/latest/users/project/) if not already added. 
- Run `ddev get weitzman/ddev-drupal-gitlabci`. From now on, each time you start DDEV your module gets symlinked into the `web/modules/custom` directory so that Drupal can find it (see [install.yaml](https://github.com/weitzman/ddev-drupal-gitlabci/blob/main/install.yaml)).
- Run `ddev composer-ci`. This edits composer.json so that `drupal/core-recommended` becomes a dev dependency.
- Run `ddev composer install` or `composer install`
- Run tests, appending options and arguments as needed. 
  - `ddev phpunit`
  - `ddev nightwatch`
  - `ddev phpcs`

Misc
=======
- Optional: [Install Chrome service for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Optional. Commit the changes in composer.json after `ddev composer-ci` runs. This saves other users from having to run this command.
- To sign up for Gitlab CI, see https://www.drupal.org/project/infrastructure/issues/3261803.

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**