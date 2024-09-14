
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

public class FuranceControl : UdonSharpBehaviour
{
    public VRCPlayerApi localPlayer;

    public Light furanceLight;
    public Material flame;
    public float flamePower;
    [UdonSynced] public float flamePowerAdded;
    public float flameFull;
    public string flamePowerName;
    public Slider flameSlider;
    public float fadingSpeed;
    public Material coal;
    public string coalTamedName;
    public float maxFurancePower;

    private void Start()
    {
        if (Networking.IsOwner(gameObject))
            RequestSerialization();

        FlamePowerChange();
    }
    public void Update()
    {
        if (!Networking.IsOwner(gameObject)) return;
        if (0 < flamePowerAdded)
        {
            if (maxFurancePower < flamePowerAdded) flamePowerAdded = maxFurancePower;
            flamePowerAdded -= fadingSpeed;
            FlamePowerChange();
            
        }
    }

    public override void OnDeserialization()
    {
        FlamePowerChange();

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
        //Debug.Log(groundColor+" ground color");
        //Debug.Log(flameFull/100 + " flameFull");

        coal.SetFloat(coalTamedName, flameFull / 10);
    }
    public void ResetPower()    
    {
        if (!Networking.IsOwner(gameObject))
        {
            Networking.SetOwner(Networking.LocalPlayer, gameObject);
        }

        Debug.Log("flame power Added");
        flamePowerAdded = 0;
        //flameFull = 0;
        RequestSerialization();
        FlamePowerChange();
    }

}
