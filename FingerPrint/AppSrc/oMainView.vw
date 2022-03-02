Use Windows.pkg
Use DFClient.pkg
Use dfBitmap.pkg
Use cComOPOSBiometrics.pkg

Deferred_View Activate_oMainView for ;
Object oMainView is a dbView
    Set Size to 200 300
    Set Location to 2 2
    Set Minimize_Icon to False
    Set piMaxSize to 200 300
    Set piMinSize to 200 300
    Set Border_Style to Border_None
    Set Color to clScrollBar
    Set Sysmenu_Icon to False
    Set Auto_Top_Item_State to False
    Set Auto_Top_Panel_State to False
    
    //proprierty
    Property String[] pasCandidates
    
    Object OPOSBiometrics is a cComOPOSBiometrics
        Set Size to 90 80
        Set Location to 110 0
        
        //Methods Rewrite
        Procedure OnComDataEvent Integer llStatus
            Forward Send OnComDataEvent llStatus
            Integer iRet
            String sBIR sData 
            
            Get ComEndCapture of OPOSBiometrics to iRet
            
            Set Value of oTextBoxStatus to "Fingerprint Scanned" 
            Get ComBIR of OPOSBiometrics to sBIR
                
            Showln ("Raw Data BIR: "+String(sBIR))   
            Showln "End ComDataEvent"
        End_Procedure
        
        Procedure OnComDirectIOEvent Integer llEventNumber Integer ByRef llpData String ByRef llpString
            Forward Send OnComDirectIOEvent llEventNumber (&llpData) (&llpString)
            String sData 
            Integer iRet
            
            If (llEventNumber = 5) Begin
                Get ComRawSensorData of OPOSBiometrics to sData
                Showln ("Raw Data: "+sData)
            End
            Else If (llEventNumber = 7) Begin
                Set Value of oTextBoxStatus to  ("Image "+String(llpData)+" captured, put same finger for image "+String(llpData + 1))
            End
            Else If (llEventNumber = 8) Begin
                Showln "Stop Event"
                Get ComEndCapture of OPOSBiometrics to iRet
            End
            
        End_Procedure 
        
        Procedure OnComStatusUpdateEvent Integer llData
            Forward Send OnComStatusUpdateEvent llData
            String sData
             
            If (llData = 1) Begin
                Showln ("Raw image data is avaible")
            End
            If (llData = 2) Begin
                Showln ("Capture Complete")
            End
            
        End_Procedure
        
    End_Object

    Object oContainerDeviceState is a Container3d
        Set Size to 110 80
        Set Location to 0 0
        
        Object oTextBoxTitleMainButtons is a TextBox
            Set Size to 10 42
            Set Location to 4 14
            Set Label to "Main Actions"
            Set Label_Shadow_Display_Mode to TBShadow_On_None
            Set FontWeight to fw_Bold
        End_Object
        
        Object oButtonOpen is a Button
            Set Location to 20 10
            Set Label to "Open"
            
        
            // fires when the button is clicked
            Procedure OnClick
                
                //Properties of the device 
                String sComDeviceName sComDeviceDescription sComServiceObjectVersion sComServiceObjectDescription sComCheckHealthText sComControlObjectDescription sComControlObjectVersion    
                Integer iRet
                 
                //Open Device. You can Check Info of the Device now
                Get ComOpen of OPOSBiometrics "DPFingerPrintReader" to iRet
                Set ComRealTimeDataEnabled  of OPOSBiometrics to True
                
                If (iRet = 0) Begin
                    //Get Info of the Device
                    Get ComDeviceName               of OPOSBiometrics to sComDeviceName
                    Get ComDeviceDescription        of OPOSBiometrics to sComDeviceDescription
                    Get ComServiceObjectVersion     of OPOSBiometrics to sComServiceObjectVersion
                    Get ComServiceObjectDescription of OPOSBiometrics to sComServiceObjectDescription
                    Get ComCheckHealthText          of OPOSBiometrics to sComCheckHealthText
                    Get ComControlObjectDescription of OPOSBiometrics to sComControlObjectDescription
                    Get ComControlObjectVersion     of OPOSBiometrics to sComControlObjectVersion
                    
                    Set Value of oFormDeviceName            to sComDeviceName
                    Set Value of oFormDeviceDescription     to sComDeviceDescription
                    Set Value of oFormCheckHealth           to sComCheckHealthText
                    Set Value of oFormServiceVersion        to sComServiceObjectVersion
                    Set Value of oFormServiceDescription    to sComServiceObjectDescription
                    Set Value of oFormControlVersion        to sComControlObjectVersion
                    Set Value of oFormControlDescriptions   to sComControlObjectDescription
                    
                    //Set to enabled state the others buttons
                    Set Enabled_State of oButtonOpen        to False
                    Set Enabled_State of oButtonClaim       to True
                    Set Enabled_State of oButtonClose       to True
                    Set Enabled_State of oButtonClearData   to False
                    
                End
                Else Send Info_Box "Error on open the device" "Warning!"
                
            End_Procedure
        
        End_Object

        Object oButtonClaim is a Button 
            Set Location to 40 10
            Set Label to "Claim"
        
            // fires when the button is clicked
            Procedure OnClick
                Integer iRet
                String sComAlgorithmList
                
                //Claim Device to Start Capture
                Get ComClaimDevice of OPOSBiometrics 2      to iRet
                Set ComDeviceEnabled of OPOSBiometrics      to True
                
                Set Enabled_State of oContainerFunctions    to True
                
//                
//                Set ComBinaryConversion     of OPOSBiometrics to True
                Set ComDataEventEnabled     of OPOSBiometrics to True
                Set ComAlgorithm            of OPOSBiometrics to 2
            End_Procedure
        
        End_Object
    
        Object oButtonClose is a Button
            Set Location to 60 10
            Set Label to "Close"
        
            // fires when the button is clicked
            Procedure OnClick
                Integer iRet
                
                //Close the connection with the Device
                Get ComClose of OPOSBiometrics "DPFingerPrintReader" to iRet
                Set ComDeviceEnabled of OPOSBiometrics to False
                
                Set Value of oFormDeviceName            to ""
                Set Value of oFormDeviceDescription     to ""
                Set Value of oFormCheckHealth           to ""
                Set Value of oFormServiceVersion        to ""
                Set Value of oFormServiceDescription    to ""
                Set Value of oFormControlVersion        to ""
                Set Value of oFormControlDescriptions   to ""
                
                //Set to enabled state the others buttons
                Set Enabled_State of oButtonOpen                to True
                Set Enabled_State of oButtonClaim               to False
                Set Enabled_State of oButtonClose               to False
                Set Enabled_State of oButtonClearData           to False
                Set Enabled_State of oContainerFunctions        to False
                    
            End_Procedure
        
        End_Object
    
        Object oButtonClearData is a Button
            Set Location to 80 10
            Set Label to "Clear Data"
        
            // fires when the button is clicked
            Procedure OnClick
                Integer iRet
                  
            End_Procedure
        
        End_Object

    End_Object
    
    
    //Contains Bitmap Frame 
//    Object oContainerBitMap is a Container3d
//        Set Size to 90 80
//        Set Location to 110 0
//        Set Color to clBtnShadow
//        
//         
//        Object oBitmapContainer1 is a BitmapContainer
//            Set Size to 88 79
//            Set Location to -1 -1
//            Set Color to clBtnShadow
//
//           
//        End_Object
//    End_Object
    
    
    Object oContainerFunctions is a Container3d
       Set Size to 200 220
       Set Location to 0 80

        Object oTextBox1 is a TextBox
            Set Size to 10 31
            Set Location to 4 89
            Set Label to "Functions"
            Set Label_Shadow_Display_Mode to TBShadow_On_None
            Set FontWeight to fw_Bold
        End_Object

        Object oButtonEnrollCapture is a Button
            Set Location to 20 10
            Set Label to 'Enroll Capture'
        
            // fires when the button is clicked
            Procedure OnClick
                Integer iRet
                
                Get ComBeginEnrollCapture of OPOSBiometrics "s"  "s" to iRet
                
                If (iRet = 0) Begin
                    Set Label of oTextBoxStatus to "Waiting Finger to Start EnrollCapture"
                End
                
            End_Procedure
        
        End_Object

        Object oButtonCapture is a Button
            Set Location to 20 80
            Set Label to 'Capture'
        
            // fires when the button is clicked
            Procedure OnClick
                Integer iRet
                
                Get ComBeginVerifyCapture of OPOSBiometrics to iRet
            End_Procedure
        
        End_Object

        Object oButtonIdentify is a Button
            Set Location to 20 150
            Set Label to 'oButton3'
            Variant vCandidateRank
            Integer iRet
        
            // fires when the button is clicked
            Procedure OnClick
                Get ComIdentify of OPOSBiometrics 1000 1000 True  vCandidateRank 3000 to iRet
            End_Procedure
        
        End_Object

        Object oButton4 is a Button
            Set Location to 40 10
            Set Label to 'oButton4'
        
            // fires when the button is clicked
            Procedure OnClick
                
            End_Procedure
        
        End_Object

        Object oButton5 is a Button
            Set Location to 40 80
            Set Label to 'oButton5'
        
            // fires when the button is clicked
            Procedure OnClick
                
            End_Procedure
        
        End_Object

        Object oButton6 is a Button
            Set Location to 40 150
            Set Label to 'oButton6'
        
            // fires when the button is clicked
            Procedure OnClick
                
            End_Procedure
        
        End_Object
        
        Object oTextBoxStatus is a TextBox
            Set Auto_Size_State to False
            Set Size to 10 189
            Set Location to 64 10
            Set Label to "Status"
            Set TextColor to 255
            Set Justification_Mode to JMode_Center
        End_Object

        Object oTabDialog is a TabDialog
            Set Size to 118 218
            Set Location to 80 0

            Object oTabPageInfo is a TabPage
                Set Label to 'Informa‡äes'

                Object oFormDeviceName is a Form
                    Set Size to 13 80
                    Set Location to 20 3
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Device Name:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormDeviceDescription is a Form
                    Set Size to 13 80
                    Set Location to 50 5
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Device Description:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormCheckHealth is a Form
                    Set Size to 13 80
                    Set Location to 80 5
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Check Health:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormControlDescriptions is a Form
                    Set Size to 13 110
                    Set Location to 20 100
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Ctrl Description:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormServiceDescription is a Form
                    Set Size to 13 110
                    Set Location to 50 100
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Service Description:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormServiceVersion is a Form
                    Set Size to 13 50
                    Set Location to 80 100
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Service Version:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
                Object oFormControlVersion is a Form
                    Set Size to 13 50
                    Set Location to 80 160
                    Set Label_Col_Offset to 0
                    Set Label_Justification_Mode to JMode_Top
                    Set Label to "Ctrl Version:"
                    Set Entry_State to False
                    Set Focus_Mode to NonFocusable
                End_Object
                
            End_Object
            
             Object oTabPage1 is a TabPage
                Set Label to 'oTabPage1'
            End_Object
        End_Object

       
       
    End_Object
    
    //Set enabled state on buttons
    Set Enabled_State of oButtonOpen            to True
    Set Enabled_State of oButtonClaim           to False
    Set Enabled_State of oButtonClose           to False
    Set Enabled_State of oButtonClearData       to False
    Set Enabled_State of oContainerFunctions    to False
    
Cd_End_Object
