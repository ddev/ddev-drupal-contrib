DDEV integration for developing Drupal contrib projects. As a general philosophy, your contributed module is the center of the universe. The codebase layout (see image below) and commands in this project [match the Gitlab CI approach](https://git.drupalcode.org/project/gitlab_templates) from the Drupal Association.

Install
===========
1. `git clone` your contrib module
2. [Add DDEV to your contrib project](https://ddev.readthedocs.io/en/latest/users/project/) if not already added.
3. Run `ddev get weitzman/ddev-drupal-gitlabci`.

Commands
============
This project provides the following DDEV container commands.

- [ddev expand-composer-json](https://github.com/weitzman/ddev-drupal-gitlabci/blob/main/commands/web/expand-composer-json). This edits composer.json so that `drupal/core-recommended` becomes a dev dependency. After this runs you may want to run `ddev composer install`
- [ddev symlink-project](https://github.com/weitzman/ddev-drupal-gitlabci/blob/main/commands/web/symlink-project). This symlinks the top level files of your project into web/moduels/custom so that Drupal finds your module. This command runs automatically on every `ddev start`. See image below.
- `ddev phpunit`. Run phpunit tests on the web/modules/custom directory.
- `ddev nightwatch`. Run nightwatch tests on the web/modules/custom directory.
- `ddev phpcs`. Run phpcs on the web/modules/custom directory.
- `ddev eslint`. Run eslint on the js files in the web/modules/custom directory.
- `ddev stylelint`. Run stylelint on the css files in the web/modules/custom directory.

Codebase layout
==================

![Folder tree](/assets/folder.png)

Misc
=======
- Optional: [Install Chrome service for FunctionalJavascript and Nightwatch tests](https://github.com/ddev/ddev-selenium-standalone-chrome).
- Optional. Commit the changes .ddev after this plugin installs. This saves other users from having to install this integration. Rerun the `ddev get` in order to update the commands from this project.
- This project reads your `project_type` from DDEV and fetches adds the corresponding version of `drupal/core-recommended` to composer.json. if you are doing something non-standard with project_type, don't use `ddev expand-composer-json` command.
- This project should work for any contrib project, including those that haven't [opted into Gitlab CI](https://www.drupal.org/project/infrastructure/issues/3261803). One advantage of that is that failures in CI are more likely to be reproducible locally when using this integration.
- If you add/remove a root file or directory, re-symlink root files via EITHER of these methods 
  - `ddev restart`
  - `ddev symlink-project`

**Contributed and maintained by [@weitzman](https://github.com/weitzman)**
