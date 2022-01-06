# frozen_string_literal: true

require 'ffi'

module Plugin::MacOSAppIcon
  module ObjC
    extend FFI::Library
    ffi_lib 'objc'

    attach_function :sel_register_name, :sel_registerName, [:string], :pointer
    attach_function :get_class, :objc_getClass, [:string], :pointer
    attach_function :create_instance, :class_createInstance, [:pointer, :int], :pointer
    attach_function :msg_send, :objc_msgSend, [:pointer, :pointer], :pointer
    attach_function :msg_send_p, :objc_msgSend, [:pointer, :pointer, :pointer], :pointer
    attach_function :msg_send_s, :objc_msgSend, [:pointer, :pointer, :string], :pointer
  end
end

Plugin.create(:macos_appicon) do
  objc = Plugin::MacOSAppIcon::ObjC

  sel_shared_application = objc.sel_register_name('sharedApplication')
  sel_set_application_icon_image = objc.sel_register_name('setApplicationIconImage:')
  sel_init_with_utf8_string = objc.sel_register_name('initWithUTF8String:')
  sel_url_with_string = objc.sel_register_name('URLWithString:')
  sel_init_with_contents_of_url = objc.sel_register_name('initWithContentsOfURL:')

  id_ns_application = objc.get_class('NSApplication')
  id_shared_app = objc.msg_send(id_ns_application, sel_shared_application)

  id_ns_string = objc.get_class('NSString')
  id_app_icon_url_str = objc.create_instance(id_ns_string, 0)
  id_app_icon_url_str = objc.msg_send_s(id_app_icon_url_str, sel_init_with_utf8_string, Skin[:icon].uri.to_s)

  id_ns_url = objc.get_class('NSURL')
  id_app_icon_url = objc.msg_send_p(id_ns_url, sel_url_with_string, id_app_icon_url_str)

  id_ns_image = objc.get_class('NSImage')
  id_app_icon_image = objc.create_instance(id_ns_image, 0)
  id_app_icon_image = objc.msg_send_p(id_app_icon_image, sel_init_with_contents_of_url, id_app_icon_url)

  objc.msg_send_p(id_shared_app, sel_set_application_icon_image, id_app_icon_image)
end
