   var curSubnav = null;
           var curNav = null;
           function switchTag(tagName, subnavName) {
               var subnav = document.getElementById(subnavName);
               var nav = document.getElementById(tagName);
               if (curNav != null) curNav.style.backgroundColor = "";
               subnav.style.display = "block";
               nav.style.backgroundColor = "#005825";
               curNav = nav;
               if (curSubnav != null)
                   curSubnav.style.display = "none";
               curSubnav = subnav;
           };
           var curSubnav1 = null;
           var curNav1 = null;
           function switchQuicklink(tagName, subnavName) {
               var subnav1 = document.getElementById(subnavName);
               var nav1 = document.getElementById(tagName);
               if (curNav1 != null) curNav1.style.backgroundColor = "";
               subnav1.style.display = "block";
               nav1.style.backgroundColor = "#D0D0DF";
               curNav1 = nav1;
               if (curSubnav1 != null)
                   curSubnav1.style.display = "none";
               curSubnav1 = subnav1;
           };