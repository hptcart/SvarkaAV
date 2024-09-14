
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using TMPro;

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
    public GameObject pipes;

    public TextMeshProUGUI currentActDebug;
    public TextMeshProUGUI lastSerialization;
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

                brokenFurance.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                lava.SetActive(false);
                furanceAnim.SetBool(brockeFuranceName, false);
                flameHorse.SetActive(false);
                flameBird.SetActive(false);
                tower.SetActive(false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);

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
                
                lava.SetActive(false);
                brokenFurance.SetActive(false);
                furanceAnim.SetBool(brockeFuranceName, false);
                flameHorse.SetActive(false);
                flameBird.SetActive(false);
                tower.SetActive(false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);

                break;
            case 2://5                
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(true);
                    bellow[i].GetComponent<BoxCollider>().enabled = true;
                }   
                furanceAnim.SetBool(brockeFuranceName, true);
                
                mainFurance.SetActive(false);
                rocks.SetActive(false);
                brokenFurance.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                lava.SetActive(false);                
                flameHorse.SetActive(false);
                flameBird.SetActive(false);
                tower.SetActive(false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);

                break;
            case 3://10 minuts                
                lava.SetActive(true);
                roboHands.SetActive(true);
                brokenFurance.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true); 

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                mainFurance.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                flameHorse.SetActive(false);
                flameBird.SetActive(false);
                tower.SetActive(false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                pipes.SetActive(false);

                break;
            case 4://15 minuts
                lava.SetActive(true);
                brokenFurance.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                flameHorse.SetActive(true);
                flameBird.SetActive(true);
                pipes.SetActive(true);

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                mainFurance.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);                
                tower.SetActive(false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                

                break;
            case 5://20 minuts  
                lava.SetActive(true);
                brokenFurance.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);                
                pipes.SetActive(true);
                tower.SetActive(true);

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                mainFurance.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);                
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                flameHorse.SetActive(false);
                flameBird.SetActive(false);

                break;
            case 6://25 minuts
                lava.SetActive(true);
                brokenFurance.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                pipes.SetActive(true);
                

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                mainFurance.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                coldLava.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                flameHorse.SetActive(false);
                flameBird.SetActive(false);
                tower.SetActive(false);
                break;
        }
        





        currentActDebug.text = "Current scene: " + currentAct.ToString();
    }
    public override void OnDeserialization()
    {
        ActChange();
        lastSerialization.text = "Last serialization " + System.DateTime.UtcNow.ToString("mm:ss:ff");


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

