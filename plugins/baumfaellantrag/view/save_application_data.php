<?php
for ($i = 0; $i < count ( $data['wood_species'] ); $i++ ) {
  $sql  = "INSERT INTO baumfaellung.antraege (
	nr,
	surname,
	forename,
	place,
	postcode,
	streetname,
	streetno,
	email,
	phone,
	fax,
	ownerinfo,
	authority_municipalitynr,
	authority_municipalityname,
	authority_districtnr,
	authority_contactperson,
	authority_email,
	authority_processingtime,
	cadastre_stateid,
	cadastre_districtid,
	cadastre_municipalityid,
	cadastre_municipalityname,
	cadastre_boundaryid,
	cadastre_boundaryname,
	cadastre_sectionid,
	cadastre_parcelId,
	cadastre_parcelno,
	statute_id,
	statute_type,
	statute_name,
	statute_alloweddiameter,
	reason,
	wood_species,
	trunk_circumference,
	crown_diameter,
	mandatereference,
	locationsketchreference,
	npa_authenticated,
  privider_id,
	tree_geometry
  )
  VALUES (
    ".$antrag_id.",
	'".$data['surname']."',
	'".$data['forename']."',
	'".$data['place']."',
	'".$data['postcode']."',
	'".$data['streetName']."',	
	'".$data['streetNo']."',
	".(($data['email'] == '') ? 'NULL' : "'".$data['email']."'").",
	".(($data['fax'] == '') ? 'NULL' : "'".$data['fax']."'").",
	".(($data['phone'] == '') ? 'NULL' : "'".$data['phone']."'").",
	'".$data['ownerinfo']."',
	".$data['authority_municipalityNr'].",
	'".$data['authority_municipalityName']."',
	'".$data['authority_districtNr']."',
	'".$data['authority_contactPerson']."',
	'".$data['authority_email']."',
	'".$data['authority_processingTime']."',
	".$data['cadastre_stateId'].",
	".$data['cadastre_districtId'].",
	".$data['cadastre_municipalityId'].",
	'".$data['cadastre_municipalityName']."',
	".$data['cadastre_boundaryId'].",
	'".$data['cadastre_boundaryName']."',
	".(($data['cadastre_sectionId'] == '') ? 'NULL' : $data['cadastre_sectionId']).",
    '".$data['cadastre_parcelId']."',
    '".$data['cadastre_parcelNo']."',
    ".(($data['statute_id'] == '') ? 'NULL' : $data['statute_id']).",
    '".$data['statute_type']."',
	'".$data['statute_name']."',
	'".$data['statute_allowedDiameter']."',
	'".$data['reason']."',
    '".$data['wood_species'][$i]."',
    ".$data['trunk_circumference'][$i].",
    ".(($data['crown_diameter'][$i] == '') ? 'NULL' : $data['crown_diameter'][$i]).",
	".(($data['mandateReference'] == '') ? 'NULL' : "'".UPLOADPATH.$data['mandateReference']."'").",
	".(($data['locationSketchReference'] == '') ? 'NULL' : "'".UPLOADPATH.$data['locationSketchReference']."'").",
	".$data['npa_authenticated'].",
  ".$data['provider_id'].",
	ST_GeometryFromText('POINT(".$data['longitude'][$i]." ".$data['latitude'][$i].")', 4326)
  )
  RETURNING id";
  #echo $sql;
  $ret = $GUI->pgdatabase->execSQL($sql, 4, 1);
  #$data['debug'][] = $sql;
}
?>