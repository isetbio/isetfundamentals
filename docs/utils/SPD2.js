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

function clamp(num, min, max) {
  // exclusive integer clamp; min is included, max is not
  if (num < min) return min;
  if (num >= max) return max-1;
  return Math.floor(num);
}

function SPD2(l, space, shifts=[0,0,0], rgb_css=false, use_factor=true) { // space in numbers
  let data = SPD2_data[space]
  if (!data) {
    console.error(`SPD2${COLORSPACES[space]} data is not loaded.`);
    return null;
  }
  for (let idx = 0; idx < data.length; idx++) {
    if (parseInt(data[idx].wavelength) == l) {
      let factor = use_factor?COLORSPACEINFO[COLORSPACES[space]].factor:1;
      if (rgb_css) {
        return `rgb(${data[idx].a*256},${data[idx].b*256},${data[idx].c*256})`
      }
      return {
        wavelength: l,
        a: data[clamp(idx-Math.floor(shifts[0]/5), 0, data.length)].a*factor,
        b: data[clamp(idx-Math.floor(shifts[1]/5), 0, data.length)].b*factor,
        c: data[clamp(idx-Math.floor(shifts[2]/5), 0, data.length)].c*factor,
      };
    }
  }
  return 0; 
}
  