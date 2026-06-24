extends RefCounted

const APP_ID := "academic-garden"


static func make_export_payload(data: Dictionary, schema_version: int, layout_version: int, exported_at: String) -> Dictionary:
	var export_data := data.duplicate(true)
	return {
		"app": APP_ID,
		"schema_version": schema_version,
		"exported_at": exported_at,
		"layout_version": layout_version,
		"data": export_data,
		"checksum": save_checksum(export_data)
	}


static func save_checksum(data: Dictionary) -> String:
	return JSON.stringify(data).sha256_text()


static func extract_import_data(payload: Dictionary, max_schema_version: int) -> Dictionary:
	if payload.is_empty():
		return {"ok": false, "message": "无法读取 JSON"}

	var imported_data: Dictionary = {}
	if payload.has("data"):
		if str(payload.get("app", "")) != APP_ID:
			return {"ok": false, "message": "不是学术花园存档"}
		if int(payload.get("schema_version", 0)) > max_schema_version:
			return {"ok": false, "message": "存档版本过新"}
		if typeof(payload.get("data")) != TYPE_DICTIONARY:
			return {"ok": false, "message": "缺少花园数据"}
		imported_data = payload["data"]
		if payload.has("checksum") and str(payload.get("checksum", "")) != save_checksum(imported_data):
			return {"ok": false, "message": "校验失败，文件可能已损坏"}
	else:
		imported_data = payload

	if not is_valid_save_data(imported_data):
		return {"ok": false, "message": "缺少必要字段"}
	return {"ok": true, "data": imported_data}


static func is_valid_save_data(data: Dictionary) -> bool:
	return data.has("zones") and typeof(data.get("zones")) == TYPE_ARRAY and data.has("decoration_catalog")
