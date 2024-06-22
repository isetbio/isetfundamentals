/*
from
http://www.cvrl.org/ -> Cone Fundamentals -> linear, 5mm
*/

var SPD2LMS_data;

function SPD2LMS_load() {
  try {
    $.ajax({
        type: "GET",
        url: "utils/SPD2LMS.csv",
        dataType: "text",
        success: function(response) {
          SPD2LMS_data = Object.values($.csv.toObjects(response)); // special line
        },
        async: false
      });

  } catch (error) {
    console.error("Error loading SPD2LMS data:", error);
  }
}


  
function SPD2LMS(l) {
  if (!SPD2LMS_data) {
    console.error("SPD2LMS data is not loaded yet.");
    return null;
  }

  for (let idx = 0; idx < SPD2LMS_data.length; idx++) {
    if (parseInt(SPD2LMS_data[idx].wavelength) == l) {
      return SPD2LMS_data[idx];
    }
  }
  return null; 
}
  