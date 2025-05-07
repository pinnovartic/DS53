param (
[String]$fecha_inicio,
[String]$fecha_fin
)


Add-Type -AssemblyName "System.IO.Compression.FileSystem"



[Reflection.Assembly]::LoadWithPartialName("OSIsoft.AFPISDK") | Out-Null
New-Object OSIsoft.AF.Asset.AFFile



$log= ""
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
$log+=  $date_inicio_log+",Inicio Ejecucion "
$log +=  $("" | Out-String)

## variables para reporte UFL e Indicadores
$fecha_inicio_ufl= get-date -Format "dd-MM-yyyy HH:mm:ss"
if($fecha_inicio -ne ""){
$version=  get-date($fecha_inicio) -Format "yyyyMMddHHmmss"
}
$rep= 0
$estado_ejecucion= "0"
$ref_log= ""
$ref_salida= ""
$reg_error= 0
$reg_esperados= 0
$registros_trabajados= 0
$ufl_reg= ''
$json_envio= ""
$string= ""
##


$hh= @{}
$hh[0]= '00'
$hh[1]= '01'
$hh[2]= '02'
$hh[3]= '03'
$hh[4]= '04'
$hh[5]= '05'
$hh[6]= '06'
$hh[7]= '07'
$hh[8]= '08'
$hh[9]= '09'
$hh[10]= '10'
$hh[11]= '11'
$hh[12]= '12'
$hh[13]= '13'
$hh[14]= '14'
$hh[15]= '15'
$hh[16]= '16'
$hh[17]= '17'
$hh[18]= '18'
$hh[19]= '19'
$hh[20]= '20'
$hh[21]= '21'
$hh[22]= '22'
$hh[23]= '23'

$version= get-date -format "ddMMyyyyHHmmss"
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Generacion de version: "+$version
$log +=  $("" | Out-String)
$repeticiones= 0
$json= ''
$json_envio= ''
$corrimiento= ''
$superficiales= ""
$flujometro= ""
$nuevo_contenido_vitacora_error= ""

$fecha_r=  get-date -format("MM/dd/yyyy HH:mm:ss")
$fecha_r
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fecha del registro: "+$fecha_r
$log +=  $("" | Out-String)
"Carga Configuracion..."
# 1 leer variables iniciales
$Ruta_ini= 'c:\Pinnovartic\API-DS53 - fase2\config.ini'
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Lee path configuracion: "+$Ruta_ini
$log +=  $("" | Out-String)

$FILE=  Get-Content $Ruta_ini
$results= @()
foreach ($LINE in $FILE) 
{
	if ($LINE.Substring(0,1) -ne "#") 
	{
		$out= Write-Output "$LINE"
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$subline= $LINE.substring(0,4)

if ($subline -ne "pass"){ 
$log+=  $date_inicio_log+",Parametro configuracion: "+$LINE
$log +=  $("" | Out-String)
}
		$out2= $out.Split(" = ")
		$results+= $out2[3]


	
	}
}

#$results
$s= $results[0]
$p= $results[2]
$u= $results[1]
$bd= $results[8]

$ue= $results[6]
$pe= $results[7]


$url_escritura= $results[9]
$njson_reenvio= $results[10]
$dias_atras_consulta= $results[11]

### ejecucion automatica   - construccion datos ejecucion
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Parametro entrada: "+$fecha_inicio
$log +=  $("" | Out-String)
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Parametro entrada: "+$fecha_fin
$log +=  $("" | Out-String)


if ($fecha_inicio -eq ""){
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Ejecucion Modo autonomo"
$log +=  $("" | Out-String)

}

$dia= get-date -Format "dd-MM-yyyy 00:00:00"
$dia= get-date($dia)
$dia

$resta= '-'+$dias_atras_consulta
$dia= $dia.AddDays($resta)
$dia


if($fecha_inicio -eq ""){
$fechageneral= get-date($dia) -Format "dd-MM-yyyy"
$fechageneral

$fecha= $dia
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fecha ejecucion(consulta): "+$fecha
$log +=  $("" | Out-String)
$fecha_inicio= $fecha
$fecha_fin= $fecha
$repeticiones= 0
}else{
$fechageneral= get-date($fecha_inicio) -Format "dd-MM-yyyy"
$fechageneral

$fecha= $fecha_inicio
$repeticiones= 0
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fecha ejecucion (consulta): "+$fecha_inicio
$log +=  $("" | Out-String)

if ($fecha_fin -ne ""){
$RestaFechas=  New-TimeSpan -Start $fecha_inicio -End $fecha_fin
$repeticiones= $RestaFechas.Days
$repeticiones

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fecha ejecucion Inicio (consulta): "+$fecha_inicio
$log +=  $("" | Out-String)
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fecha ejecucion Fin (consulta): "+$fecha_fin
$log +=  $("" | Out-String)
}else {
$fecha_fin= $fecha_inicio
}

}
  $c= 0;

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Nro de repeticiones: "+$repeticiones
$log +=  $("" | Out-String)
#########################################################
  
for($rep= 0; $rep -le $repeticiones; $rep++){

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Repeticiones nro: "+$rep
$log +=  $("" | Out-String)
  
if ( $rep -le $repeticiones ){
$resta= '-'+($repeticiones-$rep)
$fecha
"xxxxxxx"

$dia= get-date($fecha)
$dia= $dia.AddDays($resta)
"-----"
$dia

$fechageneral= get-date($dia) -Format "dd-MM-yyyy"
$fechageneral
$fecha= $dia
$dia


}else
{
$dia= get-date($fecha_fin)
$fechageneral= get-date($dia) -Format "dd-MM-yyyy"
$fechageneral

$fecha= $dia
$dia


}


$fecha
$fechageneral

 $dir_resultado=  "c:\Pinnovartic\API-DS53 - fase2\Envio\"+$fechageneral+"_"+$version
 $dir_resultado
 
    $pjson= $dir_resultado+"\json_"+$fechageneral+"_"+$version+".csv"
  New-Item  $dir_resultado -ItemType Directory


  $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Genera directorio ejecucion: "+$dir_resultado
$log +=  $("" | Out-String)
"______________________"


## Rutinas control datalog de envio informacion

$path= $results[3]
$vitacora= $results[4]+".csv"
$pathjson= $results[5]
$pvitacora= $path+$vitacora
$pvitacora2= $path+'r_'+$vitacora
#$pvitacora
$reg_vitacora= ""

  $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Genera Bitacora ejecucion: "+$pvitacora
$log +=  $("" | Out-String)
if(Test-Path -Path $pvitacora -PathType Leaf){
#### generar registro para esta iteracion 


$reg_vitacora=  Get-Content $pvitacora
$registro_nuevo= ""
#$fecha= $dia.ToString()
# registro (fechahora,estado,ultimaactualizacion)
$registro_nuevo= $fecha.ToString()+',0,'+$pjson+','+$fecha_r
$registro_nuevo +=  $("" | Out-String) 
$reg_vitacora+= $registro_nuevo
Set-Content $pvitacora $reg_vitacora 
Start-Sleep 2
$reg_vitacora=  Get-Content $pvitacora
###
$results_v= @()
foreach ($reg in $reg_vitacora) 
{
    try{
	if ($reg.Substring(0,1) -ne "#") 
	{
		$out= Write-Output "$reg"
		
		$results_v+= $out
		
	}
}catch{
  #echo "sin registro"
  }
}
}else
{
#echo "no existe"
New-Item -Path $pvitacora -ItemType File 
#### generar registro para esta iteracion 
$registro_nuevo= ""
# registro (fechahora,estado,ultimaactualizacion)
$registro_nuevo= $fecha.ToString()+','+'0'+','+$pjson+','+$fecha_r
$registro_nuevo +=  $("" | Out-String) 
Set-Content $pvitacora $registro_nuevo 
Start-Sleep 2
$reg_vitacora=  Get-Content $pvitacora
$results_v= @()
foreach ($reg in $reg_vitacora) 
{
    try {

	if ($reg.Substring(0,1) -ne "#") 
	{
		$out= Write-Output "$reg"
		
		$results_v+= $out
		
	}
}catch {
 #echo "sin registro"
}
###
}
}

 $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Conexion AF: *usuario : "+$u
$log +=  $("" | Out-String)

# rutinas de consulta af y generacion de json nuevo

 $secure_pass=  ConvertTo-SecureString -String $p -AsPlainText -Force
  $credentials=  New-Object System.Management.Automation.PSCredential ($u,$secure_pass)
  $conn= Connect-AFServer  -WindowsCredential $credentials -AFServer (Get-AFServer -Name $s) 

 
  $db= Get-AFDatabase -Name $bd -AFServer $conn


   $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Procesamiento Elementos AF: "
$log +=  $("" | Out-String)
  if($rep -eq 0 ){
  $string+= "{"
  "-----"+$rep


  }
  $cod_env= "DGA"
  $elemento=  $db.Elements
  foreach ($e in $elemento){
     foreach ($ee in $e.Elements){ 
     if ($ee.Name -eq "Cachapoal"){
       foreach ($eee in $ee.Elements){
       if ($eee.name -ne 'Pospuestos'){
          foreach ($eeee in $eee.Elements){
          [String] $corrimiento= '00'

          
          [String]$de= ''
          [String]$ne= ''
          $de= $eeee.Description
          $ne= $eeee.Name
          $ne
          $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Elementos AF: "+$ne
$log +=  $("" | Out-String)
          [String]$totev= '0'
          [String]$nivel= '0'
          [String]$caudal= '0'
          [String]$coddga= '0'
    
          [String]$cod_env= '0'
                    $d= ''
     
        
               foreach($a in $eeee.Attributes){
              
                 if($a.name -eq 'Array_STR'){
                  $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Atributos a utilizar: "+$a.GetValue().value




$log +=  $("" | Out-String)
                   $c_item= $a.GetValue().value
                   $item_paso= $c_item -split "," 
                   $item_a_mostrar= $item_paso.Trim()               
                 }

               }
                $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Generacion datos para 24 horas "
$log +=  $("" | Out-String)
              for ($i= 0; $i -lt 24; $i++){
  
               
              $fp= get-date($fechageneral) -format "dd-MM-yyyy"
   
              $hora_archivo= $hh[$i]+':00:00'
              $fecha_archivo_excel= $fechageneral # dd-MM-yyyy
        # para fechas en regimen de operacion
     #         $fecha_consulta= $day+'-'+$mon+'-'+$year+' '+$hora
     #         $fecha_archivo_excel= $day+'-'+$mon+'-'+$year

              $fecha_consulta= [OSIsoft.AF.Time.AFTime]::Parse($fp+' '+$hora)

               foreach($a in $eeee.Attributes){
               $corrimiento= ''

               if ($a.name -eq 'QueryOffSet' -and $item_a_mostrar.Contains('QueryOffSet') -eq 'True'){
             #  $fecha_consulta
         
               [String]$corrimiento= $a.GetValue($fecha_consulta).value         
               $hora= $hh[$i]+':00:'+$corrimiento
               }
                     if ($a.name -eq 'NIVEL_Cms' -and $item_a_mostrar.Contains('NIVEL_Cms') -eq 'True'){
                     $ff= ($fp.ToString().Substring(0,10)+' '+$hora)
                  #  '*'+$ff
                  
                     $fecha_consulta= [OSIsoft.AF.Time.AFTime]::Parse($ff) 
                    # $fecha_consulta.LocalTime
              

               $nivel= $a.GetValue($fecha_consulta).value
              

               if ($nivel -is [double]){
               $nivel_round= [math]::round($nivel,2,[system.midpointrounding]::AwayFromZero)
               $s_nivel= $nivel_round.ToString()
               $nivel= $s_nivel.replace(",",".")
               }

              
                $nivel
                
            
                $d=  get-date($a.GetValue($fecha_consulta).timestamp.localtime) -Format "yyyy-MM-dd HH:00:00"
          
          #     $d

             
           

              } 

              if ($a.Name -eq 'CAUDAL_lxs' -and $item_a_mostrar.Contains('CAUDAL_lxs') -eq 'True'){
              #
               
              $fecha_consulta= ($fp.ToString().Substring(0,10)+' '+$hora)
              $fecha_consulta= [OSIsoft.AF.Time.AFTime]::Parse($fecha_consulta)
               $caudal= $a.GetValue($fecha_consulta).value


               $d=  get-date($a.GetValue($fecha_consulta).timestamp.localtime) -Format "yyyy-MM-dd HH:00:00"
         # $d
          
              }
                
              if ( $ne -eq "DEVL.SAUZAL" -or $ne -eq "CAPT.EMBALSE.RAPEL" -or $ne -eq "DEVL.EMBALSE.RAPEL" ){
              if ($a.Name -eq 'CAUDAL_lxs' -and $item_a_mostrar.Contains('CAUDAL_lxs') -eq 'True'){
              $fconsulta_st= ($fp.ToString().Substring(0,10)+" "+$hh[$i]+':00:00')
              $fecha_consulta_st= [OSIsoft.AF.Time.AFTime]::Parse($fconsulta_st)
            # $fconsulta_st
              
               $s_caudal= '0'
               $caudal= $a.GetValue($fecha_consulta_st).value

               "original: "+$caudal
             
               $caudal_round= [math]::round($caudal,2,[system.midpointrounding]::AwayFromZero)
              
               "caudal redondeo "+$caudal_round

               #$s_cuadal= $caudal_round+""
              
              #"s_cuadal vale: "+$s_cuadal


                $caudal= $caudal_round.ToString();
               
             $caudal= $caudal.replace(",",".")
             $caudal
            
               $d=  get-date($a.GetValue($fecha_consulta_st).timestamp.localtime) -Format "yyyy-MM-dd HH:00:00"
      #$d
      
              }
               if ($a.Name -eq 'TotalizadorM3' -and $item_a_mostrar.Contains('TotalizadorM3') -eq 'True'){
               $fecha_consulta= ($fp.ToString().Substring(0,10)+' '+$hh[$i]+':00:00')
               $fecha_consulta= [OSIsoft.AF.Time.AFTime]::Parse($fecha_consulta)
               $totev= $a.GetValue($fecha_consulta).value
                
               $d=  get-date($a.GetValue($fecha_consulta).timestamp.localtime) -Format "yyyy-MM-dd HH:00:00"
               #$fp
               #$d
               "****"
              # $fecha_consulta
               $s_totev= ''
               $totev_round= [math]::round($totev,0,[system.midpointrounding]::AwayFromZero)
               $s_totev= $totev_round+""
               $totev= $s_totev
               
            
               #$totev
                #pause
     
                }
              }
             
              if ($a.Name -eq 'CODIGO_DGA' -and $item_a_mostrar.Contains('CODIGO_DGA') -eq 'True'){
              $fecha_consulta= get-date($fp.ToString().Substring(0,10)+' '+$hora)
              $fecha_consulta= [OSIsoft.AF.Time.AFTime]::Parse($fecha_consulta)

              
                 $coddga= $a.GetValue($fecha_consulta).value
             
                
              if($coddga.Length -ge 2 ){
                  $pre=  $coddga.substring(0,3)
              
                if($pre -eq 'JDV'){
                  $cod_env= 'JDV'
                }else{ $cod_env= "DGA"}

               }
               }
               }
              

      
              if ($coddga.Length -ge 3 -and $nivel -ne '' -and $caudal -ne '' -and $cod_env -ne '' -and $d -ne '' -and $totev -ne ''){
                 if($coddga.Length -ge 3){
                 $reg_esperados= $reg_esperados+1
                 }
             #    $caudal
             $s_caudal= ''
             $caudal_round= [math]::round($caudal,2,[system.midpointrounding]::AwayFromZero)
           #   "*"+$caudal_round
               $s_caudal= $caudal_round+""
  
               $caudal= $s_caudal
               $caudal
            #   pause
           $registros_trabajados= $registros_trabajados+1
   
              if($nivel -ne "No Data" -and $nivel -ne "Calc Failed" -and $caudal -ne "Calc Failed" -and -$caudal -ne "No Data" ){

               $string+= '"'+$c+'":{'
               $string +=  $("`n" | Out-String)
               $string+= '"TMSTAMP":"'+$d+'",'
               $string +=  $("`n" | Out-String)
               $string+= '"CODENVIO":"'+$cod_env+'",'
               $string +=  $("`n" | Out-String)
               $string+= '"CODDGA":"'+$coddga +'",'
               #$string+= "'CODDGA'= ''"
               $string +=  $("`n" | Out-String)
               try{
               $dee= $de.substring(0,100)
               }catch{
                 $dee= $de
               }
              # $dee
               $string+= '"NOMESTACION":"'+$dee+'",'
               $string +=  $("`n" | Out-String)

              try{  
               $nivel2= $nivel
             

               }catch {
                #echo "sin decimales"

               }
             
              $string+= '"NIVELEV":"'+$nivel+'",'
               $string +=  $("`n" | Out-String)

               try{
               $caudal2= $caudal
           
              } catch{
                #echo "sin decimales"
              }

               
              $string+= '"CAUDALEV":"'+$caudal+'",'
               $string +=  $("`n" | Out-String)
               
               try{
               $totev2= $totev.replace(".",",")
              
               }catch{
               #echo "sin decimales"
               }
               $string+= '"TOTALIZADOREV":"'+$totev+'"},'
               $string +=  $("`n" | Out-String)
               $c= $c+1
               
       }else
       {
           $reg_error= $reg_error+1
       }

                 try{  
               $nivel2= $nivel
             

               }catch {
                #echo "sin decimales"

               }

                try{
             /  $caudal2= $caudal
           
              } catch{
                #echo "sin decimales"
              }

                if($totev -eq "0"){
                  $superficiales+= $coddga+';'+$fecha_archivo_excel+';'+$hora_archivo+';'+$caudal2+';'+$nivel2
          
                  $superficiales +=  $("" | Out-String)

               }else{
                  $flujometro+= $coddga+';'+$fecha_archivo_excel+';'+$hora_archivo+';'+$caudal2+';'+$totev2+';'
             
                  $flujometro +=  $("" | Out-String)
                 
               }
                
                }
                
             }


              $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Generacion Archivos csv: superficiales ,flujometro"
$log +=  $("" | Out-String)
              $stfin_sup= "Código OB;Fecha Medición;Hora Medición;Caudal(l/s);Altura limnimétrica (cm)"
                 $stfin_sup +=  $("" | Out-String)
                 $stfin_sup +=  $superficiales

                  $stfin_flu= "Código OB;Fecha Medición;Hora Medición;Caudal(l/s);Totalizador(m3);Nivel Freatico(m)"
                 $stfin_flu +=  $("" | Out-String)
                 $stfin_flu +=  $flujometro
                 $coddga
                
                 
                 $path_sup= "c:\Pinnovartic\API-DS53 - fase2\Envio\"+$fechageneral+"_"+$version+'\transmision_excel_superficiales_'+$coddga+"_"+$fecha_archivo_excel+'_'+$version+'.csv'
                $path_sup

                 $log+=  $date_inicio_log+",Generacion Archivos csv: superficiales "+$path_sup
$log +=  $("" | Out-String)
                 $path_flu= "c:\Pinnovartic\API-DS53 - fase2\Envio\"+$fechageneral+"_"+$version+'\transmision_excel_flujometro_'+$coddga+"_"+$fecha_archivo_excel+'_'+$version+'.csv'
           
                 $log+=  $date_inicio_log+",Generacion Archivos csv: flujometro "+$path_flu
$log +=  $("" | Out-String)
                 if ($superficiales.Length -ne 0){
                    Remove-Item $path_sup
                    New-Item -Path $path_sup -ItemType File 
                    Set-Content $path_sup $stfin_sup
                    }
                 if($flujometro.Length -ne 0){
                    Remove-Item $path_flu
                    New-Item -Path $path_flu -ItemType File 
                    Set-Content $path_flu $stfin_flu
                    }
                    $superficiales= ''
                    $flujometro= ''

         }
        
         
         }
         }
         }
         }
        
       
  
  }
  }
 $json+= $string.substring(0,$string.Length-4)

 $json+= '}'
 $json +=  $("`n" | Out-String)

 
 
 ## guardar json en archivo con la misma hora de ejecucion
 

 $pjson= $dir_resultado+"\json_"+$fechageneral+"_"+$version+".csv"
 New-Item -Path $pjson -ItemType File    
 Set-Content $pjson $json
 $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Guarda Json: "+$pjson


$log +=  $("" | Out-String)

 $path_sup= "c:\Pinnovartic\API-DS53 - fase2\Envio\"+$fechageneral+"_"+$version+'\transmision_excel_superficiales'

 ### fin rutina genera nuevo json
 ################################################################################

 ## Rutina carga json datalogger
 $json_historico= ""
 $cadena= ''
 $contador_paquetes_reenvio= 0

 #foreach($r in $results_v){
 #$reg_linea= $r.Split(",")
 #$cr= $reg_linea[1]
 #$cr -eq "400" -or
 #if( $cr -eq "0"){
 #$re= $reg_linea[2]
 $re= $pjson
 $cadena= Get-Content $re
 $json_historico+=  $cadena
 #$contador_paquetes_reenvio= $contador_paquetes_reenvio+1
 #}
 #if($contador_paquetes_reenvio -eq $njson_reenvio){
 # break
 #}
 #}
  $json_envio= $json_historico

  $json_envio
 



 ## fin datalogger
 ################################################################################
#rutinas de envio

$date=  Get-Date
echo $date.DateTime
# carga identificacion



$User=  $ue
$Token=  $pe
$Header=  @{
    user= $User
    pass= $Token
}
 $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Prepara consulta Token: *usuario : "+$User
$log +=  $("" | Out-String)
$Parameters=  @{
        Method =  "POST"
        Uri    =  $url_escritura # "http://159.89.47.13:8081/apiw"
        Headers=  $Header
        ContentType=  "application/json"
        Body   =  $BodyJson
    }
     $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Consulta a API por Token"
$log +=  $("" | Out-String)
$r= Invoke-RestMethod @Parameters 
"Peticion de Token"
"resp.:"
$r.token

 $date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
#$log+=  $date_inicio_log+",Respuesta  Token:"+$r.token
#$log +=  $("" | Out-String)



"Json a enviar"
$body= $json_envio
"Consulta Metodo"

$autorisacion= "Bearer "+$r.token

$headers=  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization",$autorisacion)
$headers.Add("Content-Type", "text/plain")

$url= $url_escritura
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Envio Json a API "+$pjson
$log +=  $("" | Out-String)
try {
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Ejecuta Envio Json a API"
$log +=  $("" | Out-String)
$json2=  Invoke-RestMethod $url -Method 'PUT' -Headers $headers -Body $body
$json2 | ConvertTo-Json
$cr= $json2.Status
$cr

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Respuesta Envio Json a API : "+$cr
$log +=  $("" | Out-String)


} catch {

$cr= "Error API"
$nuevo_contenido_vitacora_error+= $f_operacion+",ERR,"+$cr+","+$fecha_r
 $nuevo_contenido_vitacora_error +=  $("" | Out-String) 
$cr= "403"
$estado= "Envio con Error API 403, ejecucion rechazada por el servidor"
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",error  Envio Json a API : "+$cr
$log +=  $("" | Out-String)
}
"Resp. API:"

$cr
### actualiza vitacora con respuest ultima ejecucion
$nuevo_contenido_vitacora= ""
$contador_paquetes_reenvio= 0

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Actualizacion de bitacora con respuesta API : "+$cr
$log +=  $("" | Out-String)

 foreach($r in $results_v){
 $reg_linea= $r.Split(",")
 $cod_resp= $reg_linea[1]

 if($cr -eq "400" -and $cod_resp -eq "0"){
 $f_operacion= $reg_linea[0]
 $narchivojson= $reg_linea[2]
 $nuevo_contenido_vitacora+= $f_operacion+","+$cr+","+$narchivojson+","+$fecha_r
 $nuevo_contenido_vitacora +=  $("" | Out-String) 
 $estado= 'Error en envio (forma o contenido del Json)'
 }
 
 if($cr -eq "401" ){
 $f_operacion= $reg_linea[0]
 $narchivojson= $reg_linea[2]
 $nuevo_contenido_vitacora+= $f_operacion+","+$cr+","+$narchivojson+","+$fecha_r
 $nuevo_contenido_vitacora +=  $("" | Out-String) 
 $estado= '401 no autorizado'
 }
 if($cr -eq "200" ){
 $estado= 'Envio Exitoso'
 $f_operacion= $reg_linea[0]
 $narchivojson= $reg_linea[2]
 $ff= $reg_linea[3]
 $nuevo_contenido_vitacora+= $f_operacion+","+$cod_resp+","+$narchivojson+","+$ff
 $nuevo_contenido_vitacora +=  $("" | Out-String) 
 }

 }
#####
Remove-Item $pvitacora
New-Item -Path $pvitacora -ItemType File 
Set-Content $pvitacora $nuevo_contenido_vitacora$nuevo_contenido_vitacora_error

# echo $nuevo_contenido_vitacora >> $pvitacora
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Guarda bitacora "+$pvitacora
$log +=  $("" | Out-String)

$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+=  $date_inicio_log+",Fin Ejecucion "
$log +=  $("" | Out-String)

## respaldo carpeta local
$fileejecucion= "c:\Pinnovartic\API-DS53 - fase2\CSV_log\Logejecucion_"+$version+".csv "
New-Item $fileejecucion
Set-Content $fileejecucion $log
## log envio adjunto z
$fileejecucion= $dir_resultado+"\Logejecucion_"+$version+".csv"
New-Item $fileejecucion
Set-Content $fileejecucion $log

$fileejecucion= "c:\Pinnovartic\API-DS53 - fase2\CSV_log\Logejecucion_"+$version+".csv "


### crear Zip
$aborrar= "c:\Pinnovartic\API-DS53 - fase2\temp\ArchivoAdjunto.jpg"

$ZipFileName2= "c:\Pinnovartic\API-DS53 - fase2\temp\ArchivoAdjunto.jpg"
[IO.Compression.ZipFile]::CreateFromDirectory("c:\Pinnovartic\API-DS53 - fase2\Envio\", $ZipFileName2)


$ZipFileName= "c:\Pinnovartic\API-DS53 - fase2\respaldoZip\"+$fechageneral+"_"+$version+".zip"
[IO.Compression.ZipFile]::CreateFromDirectory("c:\Pinnovartic\API-DS53 - fase2\Envio\", $ZipFileName)

$dborrar= "c:\Pinnovartic\API-DS53 - fase2\Envio\"+$fechageneral+"_"+$version
Remove-Item -Path $dborrar -Recurse
### borrar directorio

# conexion AF

$servidor_af= "CLSG2HX2VAF6001"
$bd_af= "DS53"
$elemento_af= "Procesos\Escritura\Ejecucion"
$atributo_af= "Archivo Adjunto"
$r_file= "c:\Pinnovartic\API-DS53 - fase2\temp\ArchivoAdjunto.jpg"

#$AFSDKAssembly=  Add-Type -Path ($env:PIHOME + "\AF\PublicAssemblies\4.0\OSIsoft.AFSDK.dll")
#$AFSDKAssembly=  [Reflection.Assembly]::LoadWithPartialName("OSIsoft.AFSDK") 
[Reflection.Assembly]::LoadWithPartialName("OSIsoft.AFSDK") | Out-Null
$afServers=  New-Object OSIsoft.AF.PISystems 
$afServer=  $afServers.Item($servidor_af)

#Write-host("AFServer Name: {0}" -f $afServer.Name)
$DB=  $afServer.Databases[$bd_af]
#Write-host("DataBase Name: {0}" -f $DB.Name)# Line Break
$Element=  $DB.Elements[$elemento_af]

#Write-host("Element Name: {0}" -f $Element.Name)
$Attribute=  $Element.Attributes[$atributo_af]
#Write-host("Attribute Name: {0}" -f $Attribute.Name)
[Reflection.Assembly]::LoadWithPartialName("OSIsoft.AFSDK") | Out-Null
$fileaf=  New-Object OSIsoft.AF.Asset.AFFile
$fileaf.upload($r_file)
$Attribute.SetValue($fileaf)
$DB.CheckIn()
Start-Sleep -Seconds 3
Remove-Item -Path $aborrar
# UFL

$fecha_fin_ejecucion= get-date($date_inicio_log) -format "dd-MM-yyyy HH:mm:ss"
$d_f_inicio_log= get-date($date_inicio_log) -Format "ddMMyyyyHHmmss"
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.Fecha_inicio'+','+$date_inicio_log+','+$fecha_inicio_ufl
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.Fecha_fin'+','+$date_inicio_log+','+$fecha_fin_ejecucion
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.Fecha_consulta_inicio'+','+$date_inicio_log+','+$fechageneral+" 00:00:00"
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.Fecha_consulta_fin'+','+$date_inicio_log+','+$fechageneral+" 23:59:59"
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.estado'+','+$date_inicio_log+','+$estado
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.reflog'+','+$date_inicio_log+',"'+$fileejecucion+'"'
$ufl_reg+=  $("" | Out-String)
$pjson= "c:\Pinnovartic\API-DS53 - fase2\respaldoZip\"+$fechageneral+"_"+$version+".zip"

$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.refsalida'+','+$date_inicio_log+',"'+$pjson+'"'
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.regconerror'+','+$date_inicio_log+','+$reg_error
$ufl_reg+=  $("" | Out-String)
$regtot= 0
$regtot= $registros_trabajados+$reg_error
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.registros'+','+$date_inicio_log+','+$regtot
$ufl_reg+=  $("" | Out-String)
$reg_esperados= $reg_esperados
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.registrosenviados'+','+$date_inicio_log+','+$reg_esperados
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.respuesta'+','+$date_inicio_log+','+$cr
$ufl_reg+=  $("" | Out-String)
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.trigger'+','+$date_inicio_log+',1'

$fileufl= "c:\Pinnovartic\API-DS53 - fase2\CSV_ufl\UFLLogejecucion_"+$version+".csv "
New-Item $fileufl
Set-Content $fileufl $ufl_reg

Start-Sleep -Seconds 30
$date_inicio_log=  Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$ufl_reg= ''
$ufl_reg +=  'DS53.Procesos.Escritura.Ejecucion.trigger'+','+$date_inicio_log+',0'
$fileufl= "c:\Pinnovartic\API-DS53 - fase2\CSV_ufl\UFLLogejecucion_disparadora0.csv"
New-Item $fileufl
Set-Content $fileufl $ufl_reg