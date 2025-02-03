import { multiply } from 'https://cdn.jsdelivr.net/npm/mathjs@11.5.1/+esm';
export function updateColor() {
    // Old version
    // let tr = 0, tg = 0, tb = 0;
    // let factor = COLORSPACEINFO.RGB.factor;
    // let norm = COLORSPACEINFO.RGB.norm;
    // let standard = COLORSPACEINFO.RGB.standard;
    // data.forEach(d => {
    //     let {a, b, c} = SPD2(d.wavelength, 1);
    //     tr += parseFloat(a) * d.intensity * factor * standard[0]/norm[0];
    //     tg += parseFloat(b) * d.intensity * factor * standard[1]/norm[1];
    //     tb += parseFloat(c) * d.intensity * factor * standard[2]/norm[2];
    // });
    // tr = Math.round(tr);
    // tg = Math.round(tg);
    // tb = Math.round(tb);
    
    // colorSample.style.backgroundColor = `rgb(${tr}, ${tg}, ${tb})`;

    // Update LMS color 
    var colorLMS = JSON.parse(localStorage.getItem("LMSNorm"));
    colorLMS = [colorLMS.a,colorLMS.b,colorLMS.c]
    var colorLMSCVD = JSON.parse(localStorage.getItem("LMSCVDNorm"));
    colorLMSCVD = [colorLMSCVD.a,colorLMSCVD.b,colorLMSCVD.c]

    // Update RGB color
    var colorRGB = multiply(LMS2RGB, colorLMS);
    colorRGB = colorRGB.map(chan => Math.round(25500*chan)/100)
    colorSample.style.backgroundColor = `rgb(${colorRGB[0]}, ${colorRGB[1]}, ${colorRGB[2]})`;
    localStorage.setItem("RGBStandard", JSON.stringify(colorRGB));
    // For CVD
    var colorRGBCVD = multiply(LMS2RGB, colorLMSCVD);
    colorRGBCVD = colorRGBCVD.map(chan => Math.round(25500*chan)/100)
    colorSample2.style.backgroundColor = `rgb(${colorRGBCVD[0]}, ${colorRGBCVD[1]}, ${colorRGBCVD[2]})`;

    // Update XYZ color
    var colorXYZ = multiply(LMS2XYZ, colorLMS);
    colorXYZ = colorXYZ.map(chan => Math.round(100*chan)/100)
    localStorage.setItem("XYZStandard", JSON.stringify(colorXYZ));

    // Update local storage
    localStorage.setItem("SPD", JSON.stringify(data));
}