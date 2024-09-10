
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ToMount : UdonSharpBehaviour
{
    public VRCStation seatPlace;
    public void ButtonPress()
    {
        seatPlace.UseStation(Networking.LocalPlayer);
    }
}
