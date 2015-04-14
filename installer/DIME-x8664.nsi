!include MUI2.nsh
!include "Registry.nsh"
!include x64.nsh


!define PRODUCT_NAME "DIME"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Jeremy Wu"
!define PRODUCT_WEB_SITE "http://github.com/jrywu/DIME"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
; ## HKLM = HKEY_LOCAL_MACHINE
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; ## HKCU = HKEY_CURRENT_USER

SetCompressor lzma
ManifestDPIAware true

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE 
!define MUI_HEADERIMAGE_NOSTRETCH

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "LICENSE-zh-Hant.rtf"
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
;!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"


; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "DIME-x8664.exe"
InstallDir "$PROGRAMFILES64\DIME"
ShowInstDetails show
ShowUnInstDetails show

; Language Strings
LangString DESC_REMAINING ${LANG_TradChinese} " ( �Ѿl %d %s%s )"
LangString DESC_PROGRESS ${LANG_TradChinese} "%d.%01dkB" ;"%dkB (%d%%) of %dkB @ %d.%01dkB/s"
LangString DESC_PLURAL ${LANG_TradChinese} " "
LangString DESC_HOUR ${LANG_TradChinese} "�p��"
LangString DESC_MINUTE ${LANG_TradChinese} "����"
LangString DESC_SECOND ${LANG_TradChinese} "��"
LangString DESC_CONNECTING ${LANG_TradChinese} "�s����..."
LangString DESC_DOWNLOADING ${LANG_TradChinese} "�U�� %s"
LangString DESC_INSTALLING ${LANG_TradChinese} "�w�ˤ�"
LangString DESC_DOWNLOADING1 ${LANG_TradChinese} "�U����"
LangString DESC_DOWNLOADFAILED ${LANG_TradChinese} "�U������:"
LangString DESC_VCX86 ${LANG_TradChinese} "Visual C++ 2013 Redistritable x86"
LangString DESC_VCX64 ${LANG_TradChinese} "Visual C++ 2013 Redistritable x64"
LangString DESC_VCX86_DECISION ${LANG_TradChinese} "�w�˦���J�k���e�A�������w�� $(DESC_VCX86)�A�Y�A�Q�~��w�� \
  �A�z���q�������s�������C$\n�z�n�~��o���w�˶ܡH"
LangString DESC_VCX64_DECISION ${LANG_TradChinese} "�w�˦���J�k���e�A�������w�� $(DESC_VCX64)�A�Y�A�Q�~��w�� \
  �A�z���q�������s�������C$\n�z�n�~��o���w�˶ܡH"
!define BASE_URL http://download.microsoft.com/download
;!define URL_VC_REDISTX64_2012U3  "${BASE_URL}/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU3/vcredist_x64.exe"
;!define URL_VC_REDISTX86_2012U3  "${BASE_URL}/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU3/vcredist_x86.exe";
!define URL_VC_REDISTX64_2013  ${BASE_URL}/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe
!define URL_VC_REDISTX86_2013  ${BASE_URL}/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe
;{3D6AD258-61EA-35F5-812C-B7A02152996E} for x86 VC 2012 Upate3 {ce085a78-074e-4823-8dc1-8a721b94b76d}
;{2EDC2FA3-1F34-34E5-9085-588C9EFD1CC6} for x64 VC 2012 Upate3 {a1909659-0a08-4554-8af1-2175904903a1}
;{7f51bdb9-ee21-49ee-94d6-90afc321780e} for x64 VC 2013
;{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E} for x86 VC 2013

!define VCX86_key "{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E}"
!define VCX64_key "{7f51bdb9-ee21-49ee-94d6-90afc321780e}"
  
Var "URL_VCX86"
Var "URL_VCX64"

Function .onInit
  InitPluginsDir
  StrCpy $URL_VCX86 "${URL_VC_REDISTX86_2013}"
  StrCpy $URL_VCX64 "${URL_VC_REDISTX64_2013}"
    ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"
  StrCmp $0 "" StartInstall 0

  MessageBox MB_OKCANCEL|MB_ICONQUESTION "�������ª� $0�A�����������~��w�˷s���C�O�_�n�{�b�i��H" IDOK +2
  	Abort
  ExecWait '"$INSTDIR\uninst.exe" /S _?=$INSTDIR'
   ${If} ${RunningX64}
  	${DisableX64FSRedirection}
  	IfFileExists "$SYSDIR\DIME.dll"  0 CheckX64     ;�N��Ϧw�˥��� 
  		Abort
  CheckX64:
 	${EnableX64FSRedirection}
  ${EndIf}
  IfFileExists "$SYSDIR\DIME.dll"  0 RemoveFinished     ;�N��Ϧw�˥��� 
        Abort
  RemoveFinished:     
    	MessageBox MB_ICONINFORMATION|MB_OK "�ª��w�����C"       
StartInstall:     
;!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "CheckVCRedist" VCR
  Push $R0
  ${If} ${RunningX64}
  	SetRegView 32
  	ClearErrors
  	ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${VCX64_key}" "Installed"
  	IfErrors 0 VCx64RedistInstalled
  	MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(DESC_VCX64_DECISION)" /SD IDNO IDYES +1 IDNO VCRedistInstalledAbort
  	AddSize 7000
  	nsisdl::download /TRANSLATE "$(DESC_DOWNLOADING)" "$(DESC_CONNECTING)" \
       "$(DESC_SECOND)" "$(DESC_MINUTE)" "$(DESC_HOUR)" "$(DESC_PLURAL)" \
       "$(DESC_PROGRESS)" "$(DESC_REMAINING)" \
       /TIMEOUT=30000 "$URL_VCX64" "$PLUGINSDIR\vcredist_x64.exe"
    	Pop $0
    	StrCmp "$0" "success" lbl_continue64
    	DetailPrint "$(DESC_DOWNLOADFAILED) $0"
    	Abort
     lbl_continue64:
      DetailPrint "$(DESC_INSTALLING) $(DESC_VCX64)..."
      nsExec::ExecToStack "$PLUGINSDIR\vcredist_x64.exe /q"
      ;pop $DOTNET_RETURN_CODE
VCx64RedistInstalled:
 SetRegView 32
${EndIf}
 ClearErrors
  ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${VCX86_key}" "Version"
  IfErrors 0 VCRedistInstalled
  MessageBox MB_ICONEXCLAMATION|MB_YESNO|MB_DEFBUTTON2 "$(DESC_VCX86_DECISION)" /SD IDNO IDYES +1 IDNO VCRedistInstalledAbort
  AddSize 7000
  nsisdl::download /TRANSLATE "$(DESC_DOWNLOADING)" "$(DESC_CONNECTING)" \
       "$(DESC_SECOND)" "$(DESC_MINUTE)" "$(DESC_HOUR)" "$(DESC_PLURAL)" \
       "$(DESC_PROGRESS)" "$(DESC_REMAINING)" \
       /TIMEOUT=30000 "$URL_VCX86" "$PLUGINSDIR\vcredist_x86.exe"
    Pop $0
    StrCmp "$0" "success" lbl_continue
    DetailPrint "$(DESC_DOWNLOADFAILED) $0"
    Abort
 
    lbl_continue:
      DetailPrint "$(DESC_INSTALLING) $(DESC_VCX86)..."
      nsExec::ExecToStack "$PLUGINSDIR\vcredist_x86.exe /q"
      ;pop $DOTNET_RETURN_CODE
  Goto VCRedistInstalled
VCRedistInstalledAbort:
  Quit
VCRedistInstalled:
  Exch $R0
SectionEnd


Section "MainSection" SEC01
  SetOutPath "$SYSDIR"
  SetOverwrite ifnewer
  ${If} ${RunningX64}
  	${DisableX64FSRedirection}
  	File "system32.x64\DIME.dll"
  	ExecWait '"$SYSDIR\regsvr32.exe" /s $SYSDIR\DIME.dll'
  	File "system32.x64\*.dll"
  	${EnableX64FSRedirection}
  ${EndIf}
  File "system32.x86\DIME.dll"
  ExecWait '"$SYSDIR\regsvr32.exe" /s $SYSDIR\DIME.dll'
  File "system32.x86\*.dll"
  CreateDirectory  "$INSTDIR"
  SetOutPath "$INSTDIR"
  File "*.cin"
  SetOutPath "$APPDATA\DIME\"
  ;CreateDirectory "$APPDATA\DIME"
  File "config.ini"
  
SectionEnd

Section "Modules" SEC02
SetOutPath $PROGRAMFILES64
  SetOVerwrite ifnewer
SectionEnd

Section -AdditionalIcons
  SetOutPath $SMPROGRAMS\DIME
  CreateDirectory "$SMPROGRAMS\DIME"
  CreateShortCut "$SMPROGRAMS\DIME\Uninstall.lnk" "$INSTDIRi\uninst.exe"
SectionEnd

Section -Post
  SetOutPath  "$INSTDIR"
  WriteUninstaller "$INSTDIR\uninst.exe"
  ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$SYSDIR\DIME.dll"
  ${If} ${RunningX64}
  	WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" 286
  ${Else}
  	WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" 183
   ${EndIf}
SectionEnd

Function un.onUninstSuccess  
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name)�w�������\�C" /SD IDOK
FunctionEnd

Function un.onInit
;!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "�T�w�n��������$(^Name)�H" /SD IDYES IDYES +2
  Abort
FunctionEnd

Section Uninstall
 ${If} ${RunningX64}
  ${DisableX64FSRedirection}
  ExecWait '"$SYSDIR\regsvr32.exe" /u /s $SYSDIR\DIME.dll'
  ${EnableX64FSRedirection}
 ${EndIf}
  ExecWait '"$SYSDIR\regsvr32.exe" /u /s $SYSDIR\DIME.dll'
  
  ClearErrors
  ${If} ${RunningX64}
  ${DisableX64FSRedirection}
  IfFileExists "$SYSDIR\DIME.dll"  0 +3 
  Delete "$SYSDIR\DIME.dll"
  IfErrors lbNeedReboot +1
  ${EnableX64FSRedirection}
  ${EndIf}
  IfFileExists "$SYSDIR\DIME.dll"  0  lbContinueUninstall  
  Delete "$SYSDIR\DIME.dll"
  IfErrors lbNeedReboot lbContinueUninstall

  lbNeedReboot:
  MessageBox MB_ICONSTOP|MB_YESNO "�����즳�{�����b�ϥο�J�k�A�Э��s�}���H�~�򲾰��ª��C�O�_�n�ߧY���s�}���H" IDNO lbNoReboot
  Reboot

  lbNoReboot:
  MessageBox MB_ICONSTOP|MB_OK "�бN�Ҧ��{�������A�A���հ��楻�w�˵{���C�Y���ݨ즹�e���A�Э��s�}���C" IDOK +1
  Quit
  lbContinueUninstall:
  
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\*.cin"
  RMDir /r "$INSTDIR"
  Delete "$SMPROGRAMS\DIME\Uninstall.lnk"
  ${If} ${RunningX64}
  	SetRegView 64
  ${EndIf}
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd
