This is AdminPanel script for file management of files that embedding to [WERC](http://werc.cat-v.org/) wiki. Script operates with files and directories in folder configured as file storage. It can show files as thumbnails and icons, generate embedding markdown code, upload and delete files, create subdirectories. Besides main package for proper work script needs some additional utilities - [nfile](https://github.com/sphynkx/nfile) and base64 encoder.

Script uses JS for upload/delete/copy functions and some functions may not work if your browser not properly supported JS.

## Installation

Means that werc directory placed at _/sys/www/_ and wiki placed as _sites/your&#95;host/wiki_, also file storage for wiki is _sites/your&#95;host/wiki/&#95;files_.

&nbsp;1. Download main package:

> cd /sys/www/werc/sites/wiki/&#95;werc<br>
> git/clone https://github.com/sphynkx/adm

Add contents of _config.adm_ to your _sites/your&#95;host/wiki/&#95;werc/config_.

&nbsp;2. For uploading files need to install one of base64 encoders. It is the _b64_ utility - see [b64](https://github.com/sphynkx/b64) more about it.

> cd /tmp<br>
> git/clone https://github.com/sphynkx/b64<br>
> cd b64<br>
> mk<br>
> mk install<br>

Alternatively you may install awk script [fromb64.awk](https://gist.github.com/sphynkx/518e40e3a07d308339a84c7c033808e6) and put it to _bin/contrib_ directory:

> hget https://gist.github.com/sphynkx/518e40e3a07d308339a84c7c033808e6/raw/9c0ac4b278d519068f36f9a994d075a6e1de1329/fromb64.awk>/sys/www/werc/bin/contrib/from64.awk<br>
> chmod +x /sys/www/werc/bin/contrib/from64.awk<br>

&nbsp;3. Install [nfile](https://github.com/sphynkx/nfile) utility. It is modified version of original Plan9 <a href="http://man.9front.org/1/file">file(1)</a> utility, expanded with much of filetypes and modified some MIMEs. See [more about it](https://github.com/sphynkx/nfile). Script would work with original <a href="http://man.9front.org/1/file">file(1)</a> utility but worse.

> cd /tmp<br>
> git/clone https://github.com/sphynkx/nfile
> cd nfile<br>
> mk<br>
> mk install<br>

&nbsp;4. Add link for AdminPanel in _apps/dirdir/sidebar&#95;controls.tpl_. After &lt;/form&gt; tag add next line:

> > &lt;p&gt;&lt;a href="/wiki/&#95;werc/&#95;adm/"&gt;adm&lt;/a&gt;<br>


## Configuration

All necessary parameters stored in _/wiki/&#95;werc/config_. It consists next variables:

-  _filesdir_ - directory that stores files that embeded to wiki pages. Default is _wiki/&#95;files_.

-  _icodir_ - name of subdirectory in _wiki/&#95;werc/&#95;adm/img_. Inside _$icodir_ palced directories with set icon files for different filetypes. Available values is  _'kde4'_, _'everforest'_ or custom dir with custom icons. In case of unexisted directory script will show alternate text with unicode chars, responded to separate filetypes.

-  _icosign&#95;size_ - Size of unicode symbol for filetype. Default value is _'3em'_.

-  _icopict&#95;size_ - Size of filetype icon picture. Default value is _'48px'_.

-  _picture&#95;preview_ - Show pictures in lesser format. Affect to gif, jpg, png, bmp, avif, webp images. If value is _0_ - shows filetype icons. Default is _1_.

-  _onclick_ - Let copy embedding code to clipboard by mouse click. Default value is _'onclick'_. To disable this feature change this value to something other then _'onclick'_.


## Known bugs

After delete files in subdirs script doesn&#39;t remember subdir and returns to main.

Embedding text has duplicated slashes in url.

