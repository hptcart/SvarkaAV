
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MainActChanger : UdonSharpBehaviour
{
    [UdonSynced]  public int currentAct;
    private VRCPlayerApi localPlayer;
    //public Material volumeMaterial;

    public GameObject[] bellow;
    public GameObject furanceLight;
    public GameObject mainFurance;

    public GameObject brokenFurance;
    public string brockeFuranceName;
    public Animator furanceAnim;
    public string coalDropName;
    public GameObject lava;
    public GameObject flameHorse;
    public GameObject flameBird;
    public GameObject tower;
    public GameObject coldLava;
    public GameObject flowers;
    public GameObject roboHands;
    public GameObject rocks;
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
        flameHorse.SetActive(false);
        flameBird.SetActive(false);
        tower.SetActive(false);
        coldLava.SetActive(false);
        flowers.SetActive(false);
        roboHands.SetActive(false);
        rocks.SetActive(false);
        mainFurance.SetActive(false);
        switch (currentAct)
        {
            case 0://minus ten
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(true);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                rocks.SetActive(true);
                mainFurance.SetActive(true);
                break;
            case 1://zero
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(true);
                    bellow[i].GetComponent<BoxCollider>().enabled = true;
                }
                furanceAnim.SetBool(coalDropName, true);
                rocks.SetActive(true);
                mainFurance.SetActive(true);
                break;
            case 2://5
                furanceAnim.SetBool(brockeFuranceName, true);
                break;
            case 3://10 minuts
                lava.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                roboHands.SetActive(true);
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                }
                break;
            case 4://15 minuts
                flameHorse.SetActive(true);
                flameBird.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                lava.SetActive(true);
                
                break;
            case 5://20 minuts
                furanceAnim.SetBool(brockeFuranceName, true);
                lava.SetActive(true);
                tower.SetActive(true);
                break;
            case 6://25 minuts
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

