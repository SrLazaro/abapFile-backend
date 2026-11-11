class ZCL_ZFILE_DPC_EXT definition
  public
  inheriting from ZCL_ZFILE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~READ_STREAM
    redefinition .
protected section.

  methods FILESET_DELETE_ENTITY
    redefinition .
  methods FILESET_GET_ENTITY
    redefinition .
  methods FILESET_GET_ENTITYSET
    redefinition .
  methods FILESET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZFILE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: ld_fileid  TYPE zfile-fileid,
          ls_file    TYPE zfile.

    DATA(lo_msg) = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    IF iv_slug = ''.
      lo_msg->add_message_text_only(
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = 'Slug não informado no cabeçalho'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    CLEAR ld_fileid.

    SELECT MAX( fileid )
      INTO ld_fileid
      FROM zfile.

    CLEAR ls_file.
    ls_file-fileid   = ld_fileid + 1.
    ls_file-filename = iv_slug.
    ls_file-filesize = xstrlen( is_media_resource-value ).
    ls_file-erdat    = sy-datum.
    ls_file-erzet    = sy-uzeit.
    ls_file-ernam    = sy-uname.
    ls_file-mimetype = is_media_resource-mime_type.
    ls_file-content  = is_media_resource-value.
    INSERT zfile FROM ls_file.

    copy_data_to_ref(
      EXPORTING
        is_data = ls_file
      CHANGING
        cr_data = er_entity
    ).

  ENDMETHOD.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_STREAM.

  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM.

  endmethod.


  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~READ_STREAM.

  endmethod.


  method FILESET_DELETE_ENTITY.

  endmethod.


  method FILESET_GET_ENTITY.

  endmethod.


  method FILESET_GET_ENTITYSET.

  endmethod.


  method FILESET_UPDATE_ENTITY.

  endmethod.
ENDCLASS.
