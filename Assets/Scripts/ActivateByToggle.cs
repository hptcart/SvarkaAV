
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;

public class ActivateByToggle : UdonSharpBehaviour
{
    public Toggle toggle;
    public GameObject target;
    public bool currentValue;

    public void Start()
    {
        OnValueChanged();
    }
    public void OnValueChanged()
    {
        target.SetActive(toggle.isOn);
    }
}
