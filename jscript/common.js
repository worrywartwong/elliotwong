<!--
/* common javascript functions.
 * clients only download this once.
 */
if (document.getElementById && document.createTextNode)
{
    //hide these blocks from jscript enabled browsers.
    document.write('<style type="text/css">');
    document.write('.hide_if_jscript {display:none;}');
    document.write('.show_if_jscript {display:block;}');
    document.write('</style>');
}

// popup a new browser window - a bit smaller than full screen.
// 		screenY='+topposition+',screenX='+leftposition+
function newWin(apage,aname)
{
	var h = screen.height ? screen.height : 768;
	var w = screen.width ? screen.width : 1024;

	h = h -2;
	w = w -2;
    var leftposition = 2;
    var topposition  = 2;
	
	//screenX-Y for Navigator.
    var settings =
        'height='+h+',width='+w+',top='+topposition+',left='+leftposition+
		',screenY='+topposition+',screenX='+leftposition+
        ',scrollbars=1,resizable=1,toolbar=1';

    window.open(apage,aname,settings);
}

//usual Macromedia Dreamweaver Rollover functions
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//email obfuscation
// org can be: 'c' == 'com', 'o'=='org', 'n'=='net', 'e'=='edu'
function obfuscate(name,uri,org)
{
    var s1 = "\u006d\u0061\u0069\u006c\u0074\u006f\u003a";
    var s2 = name;
    var s3 = "\u0040";

	if ( org == 'c' )
		org = 'com';
	else if ( org == 'o' )
		org = 'org';
	else if ( org == 'n' )
		org = 'net';
	else if ( org == 'e' )
		org = 'edu';
	else if ( org == 'g' )
		org = 'gov';
		
    if ( uri == null ) uri = 'francesbrann';
    if ( org == null ) org = 'com';
	
    document.write('<a href="'+s1+s2+s3+uri+'.'+org+'">');
    document.write(name+s3+uri+'.'+org);
    document.write('</a>');
}

function copyright()
{
	document.write(
		"Copyright " + 
		(new Date()).getFullYear() +
		" Frances Brann"
		);
}

// -->
