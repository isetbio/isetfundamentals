/*
from
http://www.cvrl.org/ -> Cone Fundamentals -> linear, 5mm
*/

var chromaData = [];
loadChroma();

function loadChroma() {
    try {
        $.ajax({
        type: "GET",
        url: `utils/chromaCoords.csv`,
        dataType: "text",
        success: function(response) {
            chromaData = Object.values($.csv.toObjects(response)); 
        },
        async: false
        });

    } catch (error) {
        console.error("Error loading Chromaticity data:", error);
    }
}

