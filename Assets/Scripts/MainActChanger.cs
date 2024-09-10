
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MainActChanger : UdonSharpBehaviour
{
    [UdonSynced]  public int currentAct;
    private VRCPlayerApi localPlayer;

    public GameObject[] bellow;
    public GameObject furanceLight;
    public GameObject mainFurance;

    public GameObject brokenFurance;
    public string brockeFuranceName;
    public Animator furanceAnim;
    public string coalDropName;
    public GameObject lava;
    public GameObject flameMount;
    public GameObject tower;
    public GameObject coldLava;
    public GameObject flowers;
    void Start()
    {
        localPlayer = Networking.LocalPlayer;

        currentAct = 0;
        ActChange();
        if (Networking.IsOwner(gameObject))
            RequestSerialization();
    }
    public void ActChange()
    {
        furanceAnim.SetBool(coalDropName, false);
        lava.SetActive(false);
        furanceAnim.SetBool(brockeFuranceName, false);
        flameMount.SetActive(false);
        tower.SetActive(false);
        coldLava.SetActive(false);
        flowers.SetActive(false);
        switch (currentAct)
        {
            case 0:
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                break;
            case 1:
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].GetComponent<BoxCollider>().enabled = true;
                }
                furanceAnim.SetBool(coalDropName, true);
                break;
            case 2:
                furanceAnim.SetBool(brockeFuranceName, true);
                break;
            case 3:
                lava.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                break;
            case 4:
                flameMount.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                lava.SetActive(true);
                break;
            case 5:
                furanceAnim.SetBool(brockeFuranceName, true);
                lava.SetActive(true);
                tower.SetActive(true);
                break;
            case 6:
                furanceAnim.SetBool(brockeFuranceName, true);
                coldLava.SetActive(true);
                flowers.SetActive(true);
                break;
        }

    }
    public override void OnDeserialization()
    {
        ActChange();
        
    }
    public void ActZero()
    {
        
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);

        currentAct = 0;
        ActChange();
        RequestSerialization();
    }
    public void ActOne()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 1;
        ActChange();
        RequestSerialization();
    }
    public void ActTwo()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 2;
        ActChange();
        RequestSerialization();
    }
    public void ActThree()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 3;
        ActChange();
        RequestSerialization();
    }
    public void ActFour()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 4;
        ActChange();
        RequestSerialization();
    }
    public void ActFive()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 5;
        ActChange();
        RequestSerialization();
    }
    public void ActSix()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 6;
        ActChange();
        RequestSerialization();
    }
}

