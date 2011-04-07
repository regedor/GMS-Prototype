// -------------------------------------------------------------------
// Copyright (C) 2011 Group Buddies
// -------------------------------------------------------------------
// Based on Jay Salvat work
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags 
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
mySettings = {
  onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
  markupSet: [
    {name:'Heading 1', className:'heading1',
      key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Your title here...'
    },
    {name:'Heading 2', className:'heading2',
      key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Your title here...'
    },
    {name:'Heading 3', className:'heading3',
      key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...'
    },
    {name:'Heading 4', className:'heading4',
      key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...'
    },
    {name:'Paragraph', className:'paragraph',
      key:'P', openWith:'p(!(([![Class]!]))!). '
    },
    {separator:'---------------' },
    {name:'Bold', className:'bold',
      key:'B', closeWith:'*', openWith:'*'
    },
    {name:'Italic', className:'italic',
      key:'I', closeWith:'_', openWith:'_'
    },
    {name:'Underline', className:'underline',
      key:'U', openWith:'+', closeWith:'+'
    },
    {name:'Stroke through', className:'stroke',
      key:'S', closeWith:'-', openWith:'-'
    },
    {name:'Colors', className:'colors',
      openWith:'[color=[![Color]!]]', closeWith:'[/color]', dropMenu: [
        {name:'Yellow', openWith:'%{color:yellow}', closeWith:'%', className:"col1-1" },
        {name:'Orange', openWith:'%{color:orange}', closeWith:'%', className:"col1-2" },
        {name:'Red',    openWith:'%{color:red}',    closeWith:'%', className:"col1-3" },
        {name:'Blue',   openWith:'%{color:blue}',   closeWith:'%', className:"col2-1" },
        {name:'Purple', openWith:'%{color:purple}', closeWith:'%', className:"col2-2" },
        {name:'Green',  openWith:'%{color:green}',  closeWith:'%', className:"col2-3" },
        {name:'White',  openWith:'%{color:white}',  closeWith:'%', className:"col3-1" },
        {name:'Gray',   openWith:'%{color:gray}',   closeWith:'%', className:"col3-2" },
        {name:'Black',  openWith:'%{color:black}',  closeWith:'%', className:"col3-3" }
      ]
    },
    {separator:'---------------' },
    {name:'Bulleted list', className:'bulleted',
      replaceWith:function(markItUp) { 
        var s = markItUp.selection.split((($.browser.mozilla) ? "\n" : "\r\n"));
        if (markItUp.altKey) s.reverse();
        return s.join("* \n");
      }
    },
    {name:'Numeric list', className:'numeric',
      openWith:'(!(# |!|#)!)'
    }, 
    {separator:'---------------' },
    {name:'Link', className:'link',
      openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' 
    },
    {name:'Table generator', className:'tablegenerator', 
      placeholder:"Your text here...",
      replaceWith:function(h) {
      	cols = prompt("How many cols?");
      	rows = prompt("How many rows?");
      	html = "";
      	for (r = 0; r < rows; r++) {
      	  for (c = 0; c < cols; c++) {
      	  	html += "|"+(h.placeholder||"");	
      	  }
      	  html += "|\n";
      	}
      	return html;
      }
    },
    {name:'Date', className:"date", 
      replaceWith:function() { 
        var date = new Date()
        var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        var monthname = ["January","February","March","April","May","June","July","August","September","October","November","December"];
        var D = weekday[date.getDay()];
        var d = date.getDate();
        var m = monthname[date.getMonth()];
        var y = date.getFullYear();
        var h = date.getHours();
        var i = date.getMinutes();
        var s = date.getSeconds();
        return (D +" "+ d + " " + m + " " + y + " " + h + ":" + i + ":" + s);
      }
    },
    {separator:'---------------' },
    {name:'Sort', className:"sort",
      replaceWith:function(markItUp) { 
        var s = markItUp.selection.split((($.browser.mozilla) ? "\n" : "\r\n"));
        s.sort();
        if (markItUp.altKey) s.reverse();
        return s.join("\n");
      }
    },    
    {name:'Quotes', className:'quotes', 
      openWith:'bq(!(([![Class]!]))!). '
    }
      ]
}
