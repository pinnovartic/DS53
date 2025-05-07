

# leer parametros
param (
[int]$horasatras,
[int]$diasatras,
[String]$fecha_inicio
)
$h_atras=120
if($horasatras -gt 0)
{
$h_atras=$horasatras

}
$ufl_reg=""
$log=""
# Configuracion parametros ejecucion

$log = "";
$ejecuciones_error=0
$ejecuciones_ok=0

#inicio 
# Creacion y registro de inicio en log
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$date_inicio_log_fijo=$date_inicio_log
$date_file_log=Get-Date -Format "yyyy-MM-dd_HH_mm_ss_ffff"
$log+= $date_inicio_log+",Inicio Operacion";
$log += $("" | Out-String) 

$log+= $date_inicio_log+",Dias atras para ejecucion (*-$diasatras d)";
$log += $("" | Out-String)

$diasatras=$diasatras*24*60

 if($diasatras -lt 1){ $diasatras=$h_atras-1} 

# borrado de archivo
$log+= $date_inicio_log+",Purga archivos 30 dias de creados ";
$log += $("" | Out-String)
 Get-ChildItem -Path "C:\Pinnovartic\API-DS53\CSV\" -Include *._OK -Recurse | Where-Object CreationTime -LT (Get-Date).AddDays(-30) | Remove-Item

# carga identicacion
$flag_error='0'
$User = "enel1"
$Token = "enel2022.**"
$log+= $date_inicio_log+",Identificacion user:"+$User+" , Pass:"+$Token;
$log += $("" | Out-String)
$Header = @{
    user=$User
    pass=$Token
}

$Parameters = @{
        Method      = "POST"
        Uri         = "http://159.89.47.13:8081/api"
        Headers     = $Header
        ContentType = "application/json"
        Body        = $BodyJson
    }

$i=0
for ($i;$i -lt $diasatras; $i=$i+10){
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Inicio ciclo de consultas :"+$diasatras;
$log += $("" | Out-String)


$r=Invoke-RestMethod @Parameters 
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Peticion Token ";
$log += $("" | Out-String)
"Peticion de Token"
"resp.:"
$r.token

$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Respuesta Token "+$r.token
$log += $("" | Out-String)
" "
"Consulta Metodo"
"Resp.:"
$autorisacion="Bearer "+$r.token
$Header = @{
 Method      = "GET"
        Authorization = $autorisacion
    }

$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Preparacion Fechas consulta "
$log += $("" | Out-String)



$d1=$diasatras-($i)
$d2=$diasatras-($i+9)
$d1="-"+$d1
$d2="-"+$d2
#if($fecha_inicio.length -eq 0){
#$date = Get-Date
#}else
#{
#$date = Get-Date($fecha)
#}
$diasatras
$h_atras

if ($diasatras -gt $h_atras){
$date = Get-Date -format 'yyyy-MM-dd 00:00:00'
}else { 
$date = Get-Date -format 'yyyy-MM-dd HH:mm:ss'
}
$date= Get-date($date)
$date 

$date=$date.AddMinutes($d1)
$date = Get-Date($date) -format 'yyyy-MM-dd HH:mm:ss'
$date
if ($diasatras -gt $h_atras){
$date1 = Get-Date -format 'yyyy-MM-dd 00:00:00'
}else { 
$date1 = Get-Date -format 'yyyy-MM-dd HH:mm:ss'
}

$date1= Get-date($date1)
$date1=$date1.AddMinutes("$d2")
$date2= Get-Date($date1) -format 'yyyy-MM-dd HH:mm:ss'
$date2

$url='http://159.89.47.13:8081/api?FecDesde='+$date+'&FecHasta='+$date2
#$url='http://159.89.47.13:8081/api?FecDesde=2022-10-01 23:55:00&FecHasta=2022-10-02 00:05:00'
$url
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",consulta :"+$url
$log += $("" | Out-String)
try{
$json=Invoke-RestMethod -Uri $url -Headers $Header

$json_paso=$json | ConvertTo-Json

# Archivo json, respuesta API
$fecha_respuesta=get-date($date_inicio_log) -format "yyyyMMddHHmmss"
$fecha_respuesta
$archivojsonrespuesta="C:\Pinnovartic\API-DS53\respuestas_API\jsonrespuesta"+$fecha_respuesta+".csv"
$archivojsonrespuesta
New-Item   $archivojsonrespuesta  -ItemType File
Set-Content $archivojsonrespuesta $json_paso




$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+',respuesta :'+$archivojsonrespuesta
$log += $("" | Out-String)
}catch{
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",consulta :Error al conectar  o consultar al servidor"
$log += $("" | Out-String)

}

$lj=$json 

$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Lee listado de tag a usar"
$log += $("" | Out-String)
#$lj
## leer etructura de archivo
$Ruta_ini='C:\Pinnovartic\API-DS53\Elementos.txt'
$FILE = Get-Content $Ruta_ini
$reg_esperados=0
$linea=""
$indice=1
$indice2=1
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Ciclo construccion CSV"
$log += $("" | Out-String)
$flag_error=0
$ejecuciones_error=0
foreach ($f in $File){


#$f+" "+$indice+" "+$indice2
switch($indice){
1 {
if ($indice2 -eq 1){
$altura=""
$alt_sensor=""
$bateria=""
$lectura=""
$tiempo=""
$reg_esperados+=4
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",preparando registro para:sauzalito_aa"
$log += $("" | Out-String)
foreach($j in $lj.sauzalito_aa){
$altura=$j.Alt_regla
$alt_sensor=$j.Alt_sensor
$bateria=$j.BattV
$lectura=$j.Q_caudal
$largo=$j.TmStamp.Length;
$largo=$largo-2;
$tiempo=$j.TmStamp.Substring(0,$largo)
}}

if ($indice2 -eq 2){
$altura=""
$alt_sensor=""
$bateria=""
$lectura=""
$tiempo=""
$reg_esperados+=4
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",preparando registro para:sauzalito_ab"
$log += $("" | Out-String)
foreach($j in $lj.sauzalito_ab){
$altura=$j.Alt_regla
$alt_sensor=$j.Alt_sensor
$bateria=$j.BattV
$lectura=$j.Q_caudal
$largo=$j.TmStamp.Length;
$largo=$largo-2;
$tiempo=$j.TmStamp.Substring(0,$largo)
}}

if ($indice2 -eq 3){
$altura=""
$alt_sensor=""
$bateria=""
$lectura=""
$tiempo=""
$reg_esperados+=4
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",preparando registro para:rio_claro"
$log += $("" | Out-String)
foreach($j in $lj.rio_claro){
$altura=$j.Alt_regla
$alt_sensor=$j.Alt_sensor
$bateria=$j.BattV
$lectura=$j.Q_caudal
$largo=$j.TmStamp.Length;
$largo=$largo-2;
$tiempo=$j.TmStamp.Substring(0,$largo)
}}
if ($indice2 -eq 4){
$altura=""
$alt_sensor=""
$bateria=""
$lectura=""
$tiempo=""
$reg_esperados+=4
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",preparando registro para:e_nuevo_cachapoal"
$log += $("" | Out-String)
foreach($j in $lj.e_nuevo_cachapoal){
$altura=$j.Alt_regla
$alt_sensor=$j.Alt_sensor
$bateria=$j.BattV
$lectura=$j.Q_caudal
$largo=$j.TmStamp.Length;
$largo=$largo-2;
$tiempo=$j.TmStamp.Substring(0,$largo)
}}
if ($indice2 -eq 5){
$altura=""
$alt_sensor=""
$bateria=""
$lectura=""
$tiempo=""
$reg_esperados+=4
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",preparando registro para:el_gringo"
$log += $("" | Out-String)
foreach($j in $lj.el_gringo){

$altura=$j.Alt_regla
$alt_sensor=$j.Alt_sensor
$bateria=$j.BattV
$lectura=$j.Q_caudal
$largo=$j.TmStamp.Length;
$largo=$largo-2;
$tiempo=$j.TmStamp.Substring(0,$largo)
}
}


 $indice=$indice+1
 
}
2{
$linea = $linea+$f+','+$tiempo+','+$altura
$linea += $("" | Out-String)
$indice=$indice+1
if ($altura -eq ""){


 $ejecuciones_error=$ejecuciones_error+1

$flag_error='1'
$t_errr=$tiempo
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",parametro vacio Altura"
$log += $("" | Out-String)}
}
3{
$linea =$linea+ $f+','+$tiempo+','+$alt_sensor
$linea += $("" | Out-String)
$indice=$indice+1
if ($alt_sensor -eq ""){
$flag_error='1'
 $ejecuciones_error=$ejecuciones_error+1
$t_errr=$tiempo
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",parametro vacio Altura Sensor"
$log += $("" | Out-String)
}}
4{$linea =$linea+ $f+','+$tiempo+','+$lectura
$linea += $("" | Out-String)
$indice=$indice+1
if ($lectura -eq ""){
$flag_error='1'
 $ejecuciones_error=$ejecuciones_error+1
$t_errr=$tiempo
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",parametro vacio Lectura"
$log += $("" | Out-String)
}}
5{
$linea = $linea+$f+','+$tiempo+','+$bateria
$linea += $("" | Out-String) 
$indice=1
$indice2=$indice2+1
if ($bateria -eq ""){

$flag_error='1'

 $ejecuciones_error=$ejecuciones_error+1
$t_errr=$tiempo
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",parametro vacio Bateria"
$log += $("" | Out-String)

}
}

}
 }

 $date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Control de Reg. con error "
$log += $("" | Out-String)
  $registro_nuevo=''
  $reg_vitacora=''
  $fecha=get-date -Format "dd-MM-yyyy HH:mm:ss"
  $pvitacora='C:\Pinnovartic\API-DS53\listado_error.csv'

if ($flag_error -eq "1"){
  if(Test-Path -Path $pvitacora -PathType Leaf){
  $reg_vitacora = Get-Content $pvitacora
  $registro_nuevo=$fecha+','+$url+','+$flag_error
   $date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Error: "+$registro_nuevo
$log += $("" | Out-String)
  $registro_nuevo += $("" | Out-String)
  $reg_vitacora+=$registro_nuevo
  Set-Content $pvitacora $reg_vitacora 
     
  }
  else{
  New-Item -Path $pvitacora -ItemType File 
  $registro_nuevo=$fecha+','+$url+','+$flag_error+$("" | Out-String) 
  $date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Error: "+$registro_nuevo
$log += $("" | Out-String)
  $reg_vitacora+=$registro_nuevo
  Set-Content $pvitacora $reg_vitacora 
  }
 
  $flag_error='0'

  }else{
 $ejecuciones_ok=$ejecuciones_ok+1
}
 
#Remove-Item -Path "C:\Users\cl156747815\Desktop\Pinnovartic\API-DS53\CSV\salida.csv"



$fecha_Archivosalida=get-date($date_inicio_log) -format "yyyyMMddHHmmss"
$archivosalida="C:\Pinnovartic\API-DS53\CSV\salida"+$fecha_Archivosalida+".csv"
$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Salida: "+$archivosalida
$log += $("" | Out-String)

New-Item $archivosalida 
Set-Content $archivosalida $linea


$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Escritura archico CSV salida: "
$log += $("" | Out-String)
Start-Sleep -Seconds 3

$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$log+= $date_inicio_log+",Fin ciclo ejecucion "
$log += $("" | Out-String)
}

$date_inicio_log= Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
$date_fin_log= Get-Date -Format "yyyy-MM-dd_HH_mm_ss"
$log+= $date_inicio_log+",Fin  ejecucion "
$log += $("" | Out-String)

$fileejecucion="C:\Pinnovartic\API-DS53\CSV_log\Logejecucion_"+$date_fin_log+".csv "
New-Item $fileejecucion
Set-Content $fileejecucion $log


if($ejecuciones_error -eq 0 ){
$estado="Ejecucion Exitosa"
}else
{
$estado="Ejecucion Con Error Datos en Blanco dentro del paquete entregado"
}
$d_f_inicio_log=get-date($date_inicio_log) -Format "ddMMyyyyHHmmss"
$fecha_fin_log=get-date -Format "dd-MM-yyyy HH:mm:ss"
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.Fecha_inicio'+','+$date_inicio_log+','+$date_inicio_log_fijo
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.Fecha_consulta_inicio'+','+$date_inicio_log+','+$date
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.Fecha_consulta_fin'+','+$date_inicio_log+','+$date2
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.Fecha_fin'+','+$date_inicio_log+','+$fecha_fin_log
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.estado'+','+$date_inicio_log+','+$estado
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.reflog'+','+$date_inicio_log+',"'+$fileejecucion+'"'
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.refsalida'+','+$date_inicio_log+',"'+$archivosalida+'"'
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.regconerror'+','+$date_inicio_log+','+$ejecuciones_error
$ufl_reg+= $("" | Out-String)
$regtot=0
$regtot=$ejecuciones_error+$ejecuciones_ok
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.registros'+','+$date_inicio_log+','+$regtot
$ufl_reg+= $("" | Out-String)
$ufl_reg += 'DS53.Procesos.Lectura.Ejecucion.registrosesperados'+','+$date_inicio_log+','+$reg_esperados


$fileufl="C:\Pinnovartic\API-DS53\CSV_ufl\UFLLogejecucion_"+$d_f_inicio_log+".csv "
New-Item $fileufl
Set-Content $fileufl $ufl_reg


