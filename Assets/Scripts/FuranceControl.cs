
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

public class FuranceControl : UdonSharpBehaviour
{
    public Light furanceLight;
    public Material flame;
    public float flamePower;
    public float flamePowerAdded;
    public float flameFull;
    public string flamePowerName;
    public Slider flameSlider;
    public float fadingSpeed;

    private void Start()
    {
        FlamePowerChange();
    }
    public void Update()
    {
        if (0 < flamePowerAdded)
        {
            flamePowerAdded -= fadingSpeed;
            FlamePowerChange();
        }
    }
    public void FlamePowerChange()
    {
        flamePower = flameSlider.value;
        flameFull = flamePower + flamePowerAdded;
        flame.SetFloat(flamePowerName, flameFull);
        furanceLight.intensity = flameFull;
        //Color groundColor = Color.HSVToRGB(18, 100, flameFull / 100);
        //Color groundColor = Color.HSVToRGB(0.18f, 1, flameFull / 100);
        Color groundColor = new Color(0.74f, 0.21f, 0)*flameFull / 10;
        RenderSettings.ambientGroundColor = groundColor;
        Debug.Log(groundColor+" ground color");
        Debug.Log(flameFull/100 + " flameFull");
    }

}
