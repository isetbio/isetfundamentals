/*
from
http://www.cvrl.org/ -> Cone Fundamentals -> linear, 5mm
*/

var SPD2LMS_data;

async function SPD2LMS_load() {
    try {
      const response = await $.ajax({
        type: "GET",
        url: "utils/SPD2LMS.csv", 
        dataType: "text"
      });
      SPD2LMS_data = Object.values($.csv.toObjects(response));
      console.log("Loaded LMS")
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
        return SPD2LMS_data[idx]; // Corrected to return the found object
      }
    }
    return null; // Return null if no matching wavelength is found
  }
  