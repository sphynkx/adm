<style>
.filebox
	{
	display: inline-block;
	vertical-align: top;
	text-align: center;
	border: thin dashed green;
	width: 220px;
	height: 300px;
	margin: 1em;
	position: relative;
	overflow-wrap: anywhere;
	}

.filebox_thumb
	{
	max-height: 100px;
	max-width: 200px;
	}

.filebox_checkbox
	{
	display: inline-block;
	vertical-align: bottom;
	text-align: center;
/*	border: thin dashed blue;*/
	width: 150px;
	margin: 1em;
	position: absolute;
	bottom:0px;
	left: 15px;
	right:15px;
	}

.filebox_fileinfo
	{
	float: left;
/*	border: thin dashed red;*/
	}

.submit_button
	{
	background: none!important;
	border: none;
	padding: 0!important;
	font-size: 1em;
	color: blue;
	text-decoration: underline;
	cursor: pointer;
	}

.p_head
	{
	color: black;
	font-size: 1.2em;
	font-weight: bold;
	}

.form_file_upload, .form_mkdir, .form_file_list
	{
	border: 0px dotted red;
	}

.copy_text
	{
	display: inline-block;
/*	border: thin dashed yellow;*/
	position: absolute;
	display: inline-block;
	left: 0;
	}
</style>


%(
 if(check_user) {
   echo 'You are logged in as: <b>' $logged_user '</b><hr>'
 }
 if not {
	echo '<b> Restricted area. Please <a href="/_users/login">login</a> at first.</b>'
	exit 1
	}


if(test -x /bin/b64) {}
if not if(test -x $werc_root^'/bin/contrib/'^fromb64.awk)  {}
if not echo '<p><b>Any base64 encoder didn&#x27;t found!! Upload will not work.</b></p>'

fn b64e {
	if(test -x /bin/b64) /bin/b64 -d $*
	if not if(test -x $werc_root^'/bin/contrib/'^fromb64.awk) $werc_root/bin/contrib/fromb64.awk $*
	}


filesdir_root=$werc_root/$sitedir/$filesdir

if(~ $#post_arg_filesdir_subdir 0) filesdir_subdir=''
if not filesdir_subdir=$post_arg_filesdir_subdir

filesdir_cur=$filesdir_root/$filesdir_subdir

. $filesdir_root/../_werc/_adm/fileinfo.rc


echo '
<NOTOC>
<table border=0 width=100%><tr><td>
<p class="p_head">Upload files</p>
<form action="" method="POST" onchange="readFile()" title="File upload" class="form_file_upload">
	<input type="file" value="Choose File" id="JS_getFile" name="uploadfile">
	<input type="hidden" id= "JS_hiddenUplField" name="filecont" value="">
	<input type="hidden" name="filesdir_subdir" value="'^$filesdir_subdir^'">
	<p><input type="submit" value="Upload"></p>
</form>
</td><td>
<p class="p_head">New directory</p>
<form action="" method="POST" title="mkdir" class="form_mkdir">
	<input type="text" value="" name="mkdir_name" placeholder="Enter directory name" required>
	<input type="hidden" name="filesdir_subdir" value="'^$filesdir_subdir^'">
	<p><input type="submit" value="Create"></p>
</form>
</td></tr></table>
'
if(! ~ $#post_arg_mkdir_name 0) mkdir $filesdir_root/$"post_arg_filesdir_subdir/$post_arg_mkdir_name


ifs=''
if(! ~ $#post_arg_uploadfile 0) 
	{
	echo $post_arg_filecont | b64e >$filesdir_root/$"post_arg_filesdir_subdir/$"post_arg_uploadfile
	} 


ifs='¶'
for (i in `{echo -n $"post_arg_dellist| sed 's/ //g'| sed 's/.$//'| sed 's/^undefined//'| tr -d '\x0A'}) rm $i

echo '<p class="p_head">Review and delete files</p>'

echo '<form action="" method="POST" title="List of files" class="form_file_list"><input type="submit" id="JS_DelBtn" value="Delete Selected"><p><br>'
echo -n '<input type="hidden" name="filesdir_subdir" value="'^`{if(~ $#post_arg_filesdir_subdir 0) echo -n '/'; if not echo -n $filesdir_subdir}^'">'


if(~ $#post_arg_filesdir_subdir 1) echo '<span style="font-size: '^$icosign_size^'"><img src="img/'^$icodir^'/updir.png" alt="&nldr;" height='^$icopict_size^' title="UpDir"></span><br><p><input type="submit" value="UpDir" class="submit_button"><input type="hidden" name="filesdir_subdir" class="submit_button" value=""></p>'

ifs='
'
for(i in `{ls -d $filesdir_cur/*}) {
	echo -n '<div class="filebox">' 
	fileinfo $i
	echo '<br>'
	echo '<span class="filebox_checkbox"><input type="checkbox" name="JS_DelFiles" value="' $i '"></span>'
	echo '</div>'
	}
echo -n '<input type="hidden" id= "JShiddenDelField" name="dellist" value="">'
echo '</form>' ### end of filelist form ( title="List of files")


%)


<script>
function readFile () {
  let selected = document.getElementById("JS_getFile").files[0];
  let reader = new FileReader();
  reader.addEventListener("load", () => {
	var bindata = reader.result;
	document.getElementById("JS_hiddenUplField").value = btoa(bindata);
  });
  reader.readAsBinaryString(selected);
}

function copyText(id) {
  var copyTextVar = document.getElementById(id);
  copyTextVar.select();
  copyTextVar.setSelectionRange(0, 99999); 
  navigator.clipboard.writeText(copyTextVar.value);
//  alert("Copied the text: "+copyTextVar.value);
//  console.log("Copied the text: " + copyTextVar.value);
}

document.getElementById("JS_DelBtn").onclick = function() {
	var dellist;
	var markedCheckbox = document.getElementsByName("JS_DelFiles");
	for (var checkbox of markedCheckbox) {
		if (checkbox.checked) dellist += checkbox.value + '¶';
		document.getElementById("JShiddenDelField").value = dellist;
		}
	}
</script>

