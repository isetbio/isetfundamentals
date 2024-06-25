/*
from
http://www.cvrl.org/ -> Cone Fundamentals -> linear, 5mm
*/

var SPD2_data = [];
loadAll();

function loadAll() {
  function unitLoad (fn) {
    try {
      $.ajax({
        type: "GET",
        url: `utils/${fn}`,
        dataType: "text",
        success: function(response) {
          SPD2_data.push(Object.values($.csv.toObjects(response))); 
        },
        async: false
      });
  
    } catch (error) {
      console.error("Error loading SPD2 data:", error);
    }
  }

  COLORSPACES.forEach(
    spaceName=>{
      unitLoad(`SPD2${spaceName}.csv`)
    }
  )
  
}

function SPD2(l, space, rgb_css=false) { // space in numbers
  let data = SPD2_data[space]
  if (!data) {
    console.error(`SPD2${COLORSPACES[space]} data is not loaded.`);
    return null;
  }
  for (let idx = 0; idx < data.length; idx++) {
    if (parseInt(data[idx].wavelength) == l) {
      let factor = COLORSPACEINFO[COLORSPACES[space]].factor;
      if (rgb_css) {
        return `rgb(${data[idx].a*256},${data[idx].b*256},${data[idx].c*256})`
      }
      return {
        wavelength: l,
        a: data[idx].a*factor,
        b: data[idx].b*factor,
        c: data[idx].c*factor,
      };
    }
  }
  return null; 
}
  