#include "protheus.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*Padrao Eltron
�����������������������������������������������������������������������������
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT260ACS     บAutor  ณCarlos Torres   บ Data ณ  12/03/2020     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para validar acesso a transferencia            บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT260ACS
LOCAL lRetorno  := .T.
LOCAL cCodUsu   := RetCodUsr()

IF CEMPANT="03" .AND. CFILANT="02"
    cQuery := " SELECT COUNT(ZV_CODUSU) NCOUNT FROM SZV010 SZV WITH(NOLOCK)" + ENTER
    cQuery += " WHERE ZV_CODUSU = '" + cCodUsu + "' AND ZV_FUNCAO IN ('MATA260','MATA261') " + ENTER
    cQuery += " AND ZV_MSBLQL <> '1' AND D_E_L_E_T_ <> '*' AND ZV_ATIVO = 'S'" + ENTER
    cQuery += " AND ZV_FILUSO LIKE '%4%'" + ENTER

    MemoWrite("CHECAFUNC.SQL",cQuery)
    If  Select("TRBCH") > 0
	    TRBCH->(Dbclosearea())
    Endif

    dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBCH", .F., .T.)

    dbSelectArea("TRBCH")
    If TRBCH->NCOUNT = 0
        lRetorno  := .F.
        MsgStop("Acesso nao permitido! Verifique com a gestao do CD o acesso ao modulo de trasferencia","MT260ACS")
    EndIf
    TRBCH->(Dbclosearea())

ENDIF
RETURN (lRetorno)