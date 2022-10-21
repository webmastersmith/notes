# Git

- https://github.com/UnseenWizzard/git_training
- centralized is the other way of doing version control. -centralized database, everyone pulls from one database.
- more control over who can change what.
- git is distrubted design system for version control -each person has a complete copy of git.
- everybody has a copy of the database and sycronized it when back online.
- more trust on each individual because anyone can change something
- branching and merging are fast.
- advantages: database goes down, everyone can still operate.
- version control system
- track previous versions and changes to something
- manage collaborations between different teams
- records changes to a file over time.
- tracks each contributor.
- source control management tool
- software management
- tracks: what changed, who changed it, why changed.

## Git Gui

- Kraken
- Sourcetree

**Tutorials**

- https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html
- https://github.com/UnseenWizzard/git_training
- https://www.atlassian.com/git

**Credentials**

- https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-unixes.html
- this code tells git if it points to aws, use these credentials, not the github credentials
  - `git config --global credential.helper '!aws codecommit credential-helper $@'`
  - `git config --global credential.UseHttpPath true`
  - `git remote set-url origin`

**Multiple git credentials**

- https://www.freecodecamp.org/news/how-to-handle-multiple-git-configurations-in-one-machine/
- https://dev.to/milhamh95/how-to-set-multiple-git-identities-with-git-config-4m66
- https://stackoverflow.com/questions/4220416/can-i-specify-multiple-users-for-myself-in-gitconfig
- `git config --global credentials.useHttpPath true`

**global**

- Remember that `[includeIf...]` should follows default `[user]` at the top.

```sh
[user]
    name = John Doe
    email = john@doe.tld

[includeIf "gitdir:~/work/"]
    path = ~/work/.gitconfig

# Work specific config ~/work/.gitconfig
[user]
    email = john.doe@company.tld

# another example
# ~/.gitconfig
[includeIf "gitdir:~/work/"]
    path = work-user.gitconfig
[includeIf "gitdir:~/work/github/"]
    path = user.gitconfig
```

**local .gitconfig** //go to root of directory

- `git config --global credentials.useHttpPath true`

1. clone repo
2. `git config user.name "terraform-admin-at-727"` //this will make sure you show as the committer config file is stored in the root of .git folder.
3. `git config -e` //show local config

**allows you to have multiple accounts**.

- you may not need this:
  - `git config credentials.useHttpPath true` //this will force it to ask you password and save under this path.

**Git terms to learn**

- `git stash`
- `git reset -hard origin/main`
- `git rebase`
  - https://about.gitlab.com/blog/2022/10/06/take-advantage-of-git-rebase/?utm_source=tldrnewsletter
  - `git rebase -i branchName` // i = --interactive #starts an 'interactive' rebase which will open your editor.
  - list of the commits in your branch followed by commented-out lines beginning with #. The list of commits looks like this:
  - The commits are listed in chronological order, with the oldest commit at the top #opposite of normal.
  - for inserting commits into the timeline. Inserts before head.
  - Your on your branch, git rebase someBranch //takes your head, moves aside, adds someBranch, moves head back to top.
  - rewrites history by creating new commit id's.
  - keeps git history clean
  - good for your own local branches
  - don't rebase public branches like `master/main`
  - undo rebase with `git reflog`
- `git commit amend`
- `git log`
- `git merge`
- move branch to head.
  - `git merge --squash`
  - https://medium.com/contino-engineering/git-to-know-this-before-you-do-trunk-based-development-tbd-476bc8a7c22f

**Git aliases**

- https://dev.to/imjoseangel/what-are-your-git-aliases-43om

**Fork**

- fork is specific to github. not a git command. can use the gh cli.
- fork repo from github fork button. clone to your computer. make changes. if they make changes, it will be reflected on your end. if you wan to apply your changes back to them, you must do a pull request.

**--help**

- `git config --help` //help for config cmd. full html page
- `git config -h` //short summary of options.

**.gitignore**

- websearch: javascript.gitignore

**.gitconfig** //global

- git config --global core.autocrlf true
- git config --global -e //open global in editor.

```sh
[core]
	editor = \"C:\\Users\\USERNAME\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe\" --wait
	excludesFile = C:\\Users\\USERNAME\\.gitignore_global
	autocrlf = true
[user]
	name = YOUR_NAME
	email = YOUR_EMAIL
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true
```

**Head**

- points to the most current commit.

**Log**

- the immutable history of all changes
- to remove a change, all upstream commits will have to change.
- never edit commit history once it's been made.
- don't go and reverse changes, it messes others peoples copies and breaks them.
- better to fix problems with new commit.

**show last commit**

- https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
- `git show --sumary`
- `git log` // returns list of last commits
- `git log -1 --stat` // show detail about last commit
- `git log -1` // show last commit
- `git show --name-only`
- `git show HEAD` // show last
- `git log -1 --pretty=oneline` // show commit id.
- `git log --pretty=short`
- `git log --pretty=medium`
- `git log --pretty=full`
- `git log --pretty=fuller`
- format
  - `git log -1 --pretty=format:"%H"` // show last commit hash only
  - `git log -1 --pretty=format:"%s"` // show last commit message only

**Nodes**

**Edges**

- Git maintains 3 snapshots of the files, which are stored in seperate directories.

**Working Directory**

- not tracked by git until you stage it.
- git tracks files that are new or need to be modified. If you want to track them, add to staging area.
- when you delete file, it's shadow is still in the staging area if you had added it.

**Staging Area**

- review work before it's committed to repository
- staging area can be reversed before committing to repository
- versions of files ready to be committed.
- add files to staging area:
  - `git add file1.txt file2.txt` // `git add \*.js | git add .` //all files that have been modified.
- status
  - `git status -s` //-s short status.
  - first column is staging area, second column is working directory. //A added, M modifed
- show files being tracked
  - `git ls-files`
- diff
  - `git diff --staged` //show file diffs. a/(old copy in staging) b/(new file changes)
  - @@ -1,4 +,4 @@ //
- Remove //remove file and remove file from staging
  - `git rm -h` //show help
  - `git rm file.txt` //removes file and updates staging area.
  - `git rm --cached` //remove from staging area.
  - `git rm --cached .` //remove all cache

**file to large**

- https://stackoverflow.com/questions/19573031/cant-push-to-github-because-of-large-file-which-i-already-deleted

**git status**

- After this, you should see something along the lines of On branch master Your branch is ahead of 'origin/master' by 2 commits. (use "git push" to publish your local commits) nothing to commit, working tree clean The important part is the "2 commits"! From here, go ahead and type in:
- `git reset HEAD~<HOWEVER MANY COMMITS YOU WERE BEHIND>`
- So, for the example above, one would type:
- `git reset HEAD~2`

**rename or move files**

- `git mv file1 file2` //copies file1 to file two, removes file1, updates staging area.

Git Directory Commits (snapshot) //permanent record state
repository which stores all files in an compressed form.
snapshot added to our repository.
commit when you reach a stage you want to restore to.
git commit -m "something useful"
git commit -am "something useful" //git add and commit in one line.
git commit //without message will open default editor to add multi-line comment.
write message, save, then close file to finish commit.

Initial setup
git config --global user.name "your name"
git config --global user.email "email@example.com"
echo "hello world" >> Readme.md
git init //start new repo
git add files
git commit -m "first commit"
git branch -M main
git remote add origin https://newrepo.git
git push -u origin main

Remote
Check Origin
git remote -v //show which repository it's pointing to.
git remote show origin //show more info about origin.
Remove Origin
git remote //list the origin. Remote is pointer to some repository not on your device.
git remote remove origin
Add Origin
git remote add origin YourSshFromGithub //must do next line as well.
git push -u origin main //-u same as --set-upstream //--force to make it work.
PUSH / PULL
git pull origin main // always pull from remote before pushing
git push -u origin main //choose what branch to push to.
git push //after origin established can just push to repository.
force //overwrite remote
git push --force -u origin main
Merge Abort
git merge -- abort

…or create a new repository on the command line
echo "# test" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/webmastersmith/test.git
git push -u origin main

…or push an existing repository from the command line
git remote add origin https://github.com/webmastersmith/test.git
git branch -M main
git push -u origin main

Branch
main that points to single commit
pointer to a commit.
Branch -all actions happen on local unless 'remote' is used.
https://github.com/Kunena/Kunena-Forum/wiki/Create-a-new-branch-with-git-and-manage-branches
https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell
rename branch
git branch -m <name>
assign Branch to push/pull from
https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
https://www.nobledesktop.com/learn/git/git-branches
1 . change to main branch
git branch -M main 2. set upstream remote
git remote add origin https://github.com/webmastersmith/aws_ec2_terraform.git
git push -u origin main //-u same as --set-upstream
To delete remote and push local
git push origin main -f //delete remote history
git push -u origin main
show remote branch your pointing to
https://tecadmin.net/list-all-remote-branches-in-git/
https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches
git branch //show local
git branch -r //show remote only
git branch -a //show remote and local branch info
git branch -vv //show which local branch your on and last commit message.
pull from all branches
git fetch //updates local with all remote branches
git branch -a //optionally -v to add last commit message.
show remote only repo
git ls-remote //list all remote branches
git remote -v //shows what repository you are pushing to.
push to remote
git push <remote-name> <branch-name> //<remote-name> is usually origin
git push origin newBranchName
git push --set-upstream origin branchName //-u same as --set-upstream
git checkout -b gh-pages //create and switch to branch 'gh-pages' -local only
short for git branch gh-pages //-b create branch.
short for git checkout gh-pages //move to branch
To push the current branch
git push origin <your-new-branch-name> //To publish the new branch you created in GitHub
To push and set the remote as upstream
git push --set-upstream origin <branch-name> //<old-branch-name> if you are not in the branch you want to duplicate.
https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging
this is now the 'head' and controls all pushes.
switch branch
git checkout main //switches to main, reverting work on other branch back to main.
git branch //show what branch your on.
to merge branch
https://stackabuse.com/git-merge-branch-into-master/
git checkout main //locally now you can merge 'new-branch' with 'main' branch
git merge new-branch //locally merges new-branch into the currently active branch locally.
this changes local 'main' only, then you have to git push to change remote branch.
git pull //will pull changes from remote to local.
Check if branch's need merged:
git branch --no-merged //find which local branches have not been merged with head.
git branch --merged //find branches that have been merged
to delete branch
https://www.freecodecamp.org/news/how-to-delete-a-git-branch-both-locally-and-remotely/
git branch -D <name-of-branch> //remove local branches.
git push origin --delete gh-pages //delete github branch.
can also: git push origin :gh-pages
// synchronize branch
git fetch -p
The -p flag means "prune". After fetching, branches which no longer exist on the remote, local branch will be deleted.
git branch -d gh-pages //delete local branch. -D is force even if there are changes.
Updates were rejected because the tip of your current branch is behind
git pull origin main --allow-unrelated-histories //will merge and possibly delete some files. Make a backup first.

Cache
git rm --cached fileName //remove from staging
git rm -r --cached foldername. //remove directory staging
From entire repository history
https://myopswork.com/how-remove-files-completely-from-git-repository-history-47ed3e0c4c35
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch path_to_file" HEAD
git push -all

Connect
git add origin SERVER

Commit
git reset --soft HEAD~1 //undo last commit
https://www.git-tower.com/learn/git/faq/undo-last-commit/
Undo pushed commit
https://dev.to/github/how-to-undo-pushed-commits-with-git-2pe6

Clone
git clone https://github.com/.../.git
git clone -b <branchname> --single-branch <remote-repo-url>

Pages -GH

# build.cmd

@ECHO off
rmdir /Q /S .\build
git push origin --delete gh-pages
npm run deploy

Remove from local and github
git rm fileName
