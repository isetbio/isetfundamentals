/*
from
http://www.cvrl.org/ -> Stile's data sets -> Stiles & Burch colour matching functions -> Stiles & Burch (1959) 10-deg, RGB CMFs, W
*/

var SPD2RGB_data;

function SPD2RGB_load() {
     try {
          $.ajax({
               type: "GET",
               url: "utils/SPD2RGB.csv",
               dataType: "text",
               success: function (response) {
                    SPD2RGB_data = Object.values($.csv.toObjects(response)); // special line
               },
               async: false
          });

     } catch (error) {
          console.error("Error loading SPD2RGB data:", error);
     }
}



function SPD2RGB(l, css = false) {
     if (!SPD2RGB_data) {
          console.error("SPD2RGB data is not loaded yet.");
          return null;
     }

     for (let idx = 0; idx < SPD2RGB_data.length; idx++) {
          if (parseInt(SPD2RGB_data[idx].wavelength) == l) {
               if (css) {
                    return `rgb(${SPD2RGB_data[idx].r*256},${SPD2RGB_data[idx].g*256},${SPD2RGB_data[idx].b*256})`
               } else {
                    return SPD2RGB_data[idx];
               }
          }
     }
     return null;
}
