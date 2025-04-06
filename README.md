# .home
.home.sh script for persistent UCloud directories

## motivation
When you are working with UCloud, setting up the environment can take time and efforts for each app instance started. That’s why there are init scripts, but keeping them updated and adapting them also takes time and efforts. Also, you really want to have conda environments, huggingface caches etc. available in no time. This feature of a “persistent home directory” is enabled by a recent feature in UCloud that now allows passing extra variables.

## how to
You clone .home on your UCloud drive:
```bash
cd /work/drive
git clone https://github.com/schneiderkamplab/.home.git
ln -s .home/.home.sh .
```
Then you move whatever files you want to persist to the .home directory

When you set the “/work/drive/.home.sh” script as your init script, it will try to find a folder “.home” on some of the mounted drives. If it does so, it will link all its contents over to the home directory of the instance.

For example, if you mount the “drive” drive, set “.home.sh” as your init script, and have files “.bash_history”, “.bashrc”, and “miniconda3” in the “/work/drive/.home” folder, you will get three symbolic links in “/home/ucloud”:
```bash
    .bash_history -> /work/drive/.home/.bash_history
    .bashrc -> /work/drive/.home/.bashrc
    miniconda3 -> /work/drive/.home/miniconda3
```
Files that are NOT found in /work/drive/.home are left untouched. So, if you want to persist another file or directory, just move it to /work/drive/.home and make a symbolic link to it in your home directory. “.home.sh” will ensure that the same symbolic link is made next time you start an app instance.

If you mount multiple drives with “.home” folders or want to specify a different folder, you can pass a json config as “Extra options”. For setting “/work/somedrive/somedirectory” as your persistent home directory, you simply pass the following string:
```json
    {"home": "/work/somedrive/somedirectory"}
```

If you have ideas what other configuration options .home.sh should support, just let me know. Note that things like source conda.sh etc. can be done from a persistent .bashrc.

One thing that comes to my mind when thinking about it would be to have a “run” config option, where one can specify an arbitrary command. A bit like setting a batch script from one of the drives but with the ability to pass an arbitrary script (without shebang, it will be a bash script – with a shebang anything you want).
Example 1 (just some bash):
```json
    {"run": ". ~/miniconda3/etc/profile.d/conda.sh; conda activate dolma; cd /work/drive; dolma -c mix.yaml mix"}
```
Example 2 (
```json
    {"run": "#!/usr/bin/env python\nimport os\nprint(f\"Hello world from {os.getcwd()}\")"}
```