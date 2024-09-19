
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
    public GameObject bellowAll;
    public GameObject furanceLight;
    public GameObject mainFurance;
    public ReflectionProbe reflProb;

    
    public string brockeFuranceName;
    public Animator furanceAnim;
    public string coalDropName;
    public string lavaName;
    public GameObject lava;
    public GameObject flameMounts;
    public GameObject flameBird;
    public GameObject tower;
    public GameObject scrap;
    
    public GameObject roboHands;
    public GameObject rocks;
    public RocksBrocke[] rocksAll;
    public GameObject pipes;
    public GameObject watercans;
    public GameObject metallUnicorn;
    public GameObject flowers;

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
                bellowAll.SetActive(true);
                rocks.SetActive(true);
                mainFurance.SetActive(true);

                
                furanceAnim.SetBool(coalDropName, false);
                
                furanceAnim.SetBool(brockeFuranceName, false);
                furanceAnim.SetInteger(lavaName, 0);
                
                flameMounts.SetActive(false);
                //flameBird.SetActive(false);
                tower.SetActive(false);
                scrap.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);

                break;
            case 1://zero
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(true);
                    bellow[i].GetComponent<BoxCollider>().enabled = true;
                }
                bellowAll.SetActive(true);
                furanceAnim.SetBool(coalDropName, true);
                rocks.SetActive(true);
                mainFurance.SetActive(true);
                
                
                furanceAnim.SetInteger(lavaName, 0);
                scrap.SetActive(false);
                furanceAnim.SetBool(brockeFuranceName, false);
                flameMounts.SetActive(false);
                //flameBird.SetActive(false);
                tower.SetActive(false);
                
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);

                break;
            case 2://5                
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(true);
                    bellow[i].GetComponent<BoxCollider>().enabled = true;
                }
                bellowAll.SetActive(true);
                furanceAnim.SetBool(brockeFuranceName, true);
                furanceAnim.SetInteger(lavaName, 1);
                furanceAnim.SetBool(coalDropName, false);
                scrap.SetActive(true);

                //mainFurance.SetActive(false);
                rocks.SetActive(false);       
                furanceAnim.SetBool(coalDropName, false);
                flameMounts.SetActive(false);                
                tower.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                pipes.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);

                break;
            case 3://10 minuts                
                
                roboHands.SetActive(true);
                
                furanceAnim.SetBool(brockeFuranceName, true);
                furanceAnim.SetInteger(lavaName, 1);
                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                scrap.SetActive(true);
                bellowAll.SetActive(false);

                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                flameMounts.SetActive(false);                
                tower.SetActive(false);
                
                flowers.SetActive(false);
                pipes.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);

                break;
            case 4://15 minuts
                
                
                furanceAnim.SetBool(brockeFuranceName, true);
                furanceAnim.SetInteger(lavaName, 1);
                flameMounts.SetActive(true);
                //flameBird.SetActive(true);
                pipes.SetActive(true);

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                bellowAll.SetActive(false);
                //mainFurance.SetActive(false);

                furanceAnim.SetInteger(lavaName, 1);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);                
                tower.SetActive(false);
                scrap.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);


                break;
            case 5://20 minuts  
                
                
                furanceAnim.SetBool(brockeFuranceName, true);
                furanceAnim.SetInteger(lavaName, 2);
                pipes.SetActive(true);
                tower.SetActive(true);

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                bellowAll.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                scrap.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                flameMounts.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);


                break;
            case 6://25 minuts             
                
                furanceAnim.SetBool(brockeFuranceName, true);
                pipes.SetActive(true);
                furanceAnim.SetInteger(lavaName, 2);


                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                bellowAll.SetActive(false); ;
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                scrap.SetActive(false);
                roboHands.SetActive(false);
                flameMounts.SetActive(false);                
                tower.SetActive(false);
                watercans.SetActive(false);
                metallUnicorn.SetActive(false);
                break;

            case 7://30 minuts
                
                
                furanceAnim.SetBool(brockeFuranceName, true);
                furanceAnim.SetInteger(lavaName, 2);

                watercans.SetActive(true);
                metallUnicorn.SetActive(true);
                flowers.SetActive(true);

                for (int i = 0; i < bellow.Length; i++)
                {
                    bellow[i].SetActive(false);
                    bellow[i].GetComponent<BoxCollider>().enabled = false;
                }
                bellowAll.SetActive(false);
                rocks.SetActive(false);
                furanceAnim.SetBool(coalDropName, false);
                pipes.SetActive(false);
                scrap.SetActive(false);
                flowers.SetActive(false);
                roboHands.SetActive(false);
                flameMounts.SetActive(false);
                tower.SetActive(false);
                
                break;
        }
        reflProb.RenderProbe();

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
    public void ActSeven()
    {
        if (!Networking.IsOwner(gameObject))
            Networking.SetOwner(localPlayer, gameObject);
        currentAct = 7;
        ActChange();
        RequestSerialization();
    }


    public void DisastRocks()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "DisastRocksSync");        
    }
    public void DisastRocksSync()
    {                
        for (int i = 0; i < rocksAll.Length;i++)
        {
            rocksAll[i].durability = 1;
            rocksAll[i].hit();
        }
    }

    public void RepairRocks()
    {
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "RepairRocksSync");
    }
    public void RepairRocksSync()
    {
        for (int i = 0; i < rocksAll.Length; i++)
        {
            rocksAll[i].durability = 100;
            rocksAll[i].hit();
        }
    }
}

