
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;

public class ToggleAnimation : UdonSharpBehaviour
{
    public Animator animator;
    public string animName;
    public Toggle toggle;

    private void Start()
    {
        ToggleChange();
    }
    public void ToggleChange()
    {
        animator.SetBool(animName, toggle.isOn);
    }
}
