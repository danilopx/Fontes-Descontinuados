#INCLUDE "SPEDNFE.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#DEFINE TAMMAXXML  GetNewPar("MV_XMLSIZE",400000) 

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SPDNFE01  บAutor  ณ Carlos Torres i บ Data ณ  26/11/2020   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este ponto de entrada ้ utilizado para filtrar as NF’s na  บฑฑ
ฑฑบ          ณ Exporta็ใo, permitindo exportar ou nใo a NF.               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบModifica  ณ Implementado para atender chamado do GLPI 2168             บฑฑ
ฑฑบAutor	 ณ Carlos Torres   					บData: ณ	27/11/2020 	  บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SPDNFE01
Local oNF     := ParamIXB[1]
Local lRet    := .T.
Local cChvNFe := ""
// LOCAL CTIPONF := ""
// LOCAL CNUMNFE := ""
// LOCAL CSERIENFE:= ""
//LOCAL _cQuery   := ""
Local aArea  := GetArea()
LOCAL CTIPOXML  := ""
LOCAL oXmlExp

IF CEMPANT="03" .AND. CFILANT="01"
    CTIPONF := IIF( AT("SF2",GetCbSource(bFiltraBrw)) != 0 ,"1","2")
    cChvNFe := NfeIdSPED(oNF:oWSNFe:cXML,"Id")
    IF UPPER(SUBSTRING(cChvNFe,1,3))='NFE'
        oXmlExp := XmlParser(oNF:oWSNFe:cXML,"","","")
        CTIPOXML := AllTrim(oXmlExp:_NFE:_INFNFE:_IDE:_TPNF:TEXT)
        lRet    := .F.
        //.AND. .NOT. ("INUT"$oNF:oWSNFeCancelada:cXML)
        IF CTIPONF="1" .AND. CTIPOXML="1"
            lRet    := .T.
        ELSEIF CTIPONF="2" .AND. CTIPOXML="0"
            lRet    := .T.
        EndIf
        If .NOT. (oNF:OWSNFECANCELADA<>Nil .And. !Empty(oNF:oWSNFeCancelada:cProtocolo)) 
            lRet    := .F.
        EndIf
    Endif
EndIf
RestArea(aArea)
Return lRet
