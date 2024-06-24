/*
from
http://www.cvrl.org/ -> Cone Fundamentals -> linear, 5mm
*/

var SPD2XYZ_data;

function SPD2XYZ_load() {
  try {
    $.ajax({
        type: "GET",
        url: "utils/SPD2XYZ.csv",
        dataType: "text",
        success: function(response) {
          SPD2XYZ_data = Object.values($.csv.toObjects(response)); // special line
        },
        async: false
      });

  } catch (error) {
    console.error("Error loading SPD2XYZ data:", error);
  }
}


function SPD2XYZ(l) {
  if (!SPD2XYZ_data) {
    console.error("SPD2XYZ data is not loaded yet.");
    return null;
  }

  for (let idx = 0; idx < SPD2XYZ_data.length; idx++) {
    if (parseInt(SPD2XYZ_data[idx].wavelength) == l) {
      return SPD2XYZ_data[idx];
    }
  }
  
  return null; 
}
  