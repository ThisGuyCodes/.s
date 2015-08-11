# dots
My dotfiles

This is actually the beginnings of an experiment. I'd like to create some sort of tool that makes it easy for people to create and manage git repositories of their dotfiles.

I forsee this having two main stages:
 1. semi automated backup of *my* dotfiles
 1. a tool to backup *a person's* dotfiles

Presently I'm still working on stage one.

A few important features I'd like the tool to have:
- [ ] Known list of common dotfiles ("sane defaults"), this part I imagine will be a "discover over time" thing; likely relying mostly on contributors.
- [ ] Toggleable "sections" of things to look for/check in.
- [ ] Ability to configure new files to track.
- [ ] For each dotfile (or dotfile type, as I may architect it), a growing list of "bad patterns" to save the user from (easiest examples here are API keys), with varying levels (warn, require explicit ignore, and outright refusal).
- [ ] Some more advanced autodetection (ie: if you're using neobundle only check in the lock file, not the bundle sub-directories).

My general intended structure here is along the lines of:
 1. Run a command to "detect" file layouts/options (confirming things with the user), this will generate a config.
  - During this, each file that *would* be checked in with the to-be-generated config is scanned for known "bad patterns", and each will either generate a warning, require user confirmation, or outright refuse to add the option to check in that file to the config, as appropriate.
  - Warnings, confirmations, and refusals will *always* include a "why this is/may be bad" and a "how to avoid this". Ie: the `.secrets` file I employ in my `.zshrc`. (This is what I do, there may be a better solution).
 2. With a config (checked into the new dotfiles repository), run a second command to get the files as appropriate based on the config.
  - The same checks will be run again on any file detected to have changed. *All* warnings will be printed. Those with unconfirmed confirmation-required patterns will ask for confirmation (and log it to the config), or refuse to check it in. Likewise files with any refusal patterns will not be backed up (and an appropriate message printed).
  - As above, all warnings/confirmations/refusals *will* include a why, and how.
  - The exit code of this program will be a count of files that were refused to be backed up.
 3. A third command will allow for an interactive exploration/modification of a config (explain what parts do, ask questions to add new parts: "do you use vim", etc.).

 I feel it goes without saying, but the "bad patterns" portion of this will be the most important; as people who use automation things like this generally don't care, and tend to not check their email, where they're getting warnings from amazon about some github repo they have.
