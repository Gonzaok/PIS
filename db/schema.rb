# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121031214746) do

  create_table "blackboards", :force => true do |t|
    t.integer  "proyecto_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "blackboards", ["proyecto_id"], :name => "index_blackboards_on_proyecto_id"

  create_table "clientes", :force => true do |t|
    t.string   "nombre"
    t.string   "idioma"
    t.binary   "imagen"
    t.string   "imagenFilename"
    t.string   "imagenType"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "language",           :null => false
    t.text     "image",              :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "clients", ["name"], :name => "index_clients_on_name", :unique => true

  create_table "comentarios", :force => true do |t|
    t.string   "comentario",   :limit => 1500
    t.string   "tipo"
    t.boolean  "visible"
    t.integer  "contenido_id"
    t.integer  "estado_id"
    t.integer  "usuario_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "comentarios", ["contenido_id"], :name => "index_comentarios_on_contenido_id"
  add_index "comentarios", ["estado_id"], :name => "index_comentarios_on_estado_id"
  add_index "comentarios", ["usuario_id"], :name => "index_comentarios_on_usuario_id"

  create_table "comments", :force => true do |t|
    t.text     "comment",    :null => false
    t.integer  "content_id"
    t.integer  "mood_id"
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["content_id"], :name => "index_comments_on_content_id"
  add_index "comments", ["mood_id"], :name => "index_comments_on_mood_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contenidos", :force => true do |t|
    t.integer  "usuario_id"
    t.integer  "blackboard_id"
    t.string   "resumen",         :limit => 500
    t.string   "contenido",       :limit => 1500
    t.boolean  "visible_admin"
    t.boolean  "visible_mooveit"
    t.boolean  "visible_cliente"
    t.string   "tipo"
    t.string   "relevancia"
    t.integer  "valor"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "contenidos", ["blackboard_id"], :name => "index_contenidos_on_blackboard_id"
  add_index "contenidos", ["usuario_id"], :name => "index_contenidos_on_usuario_id"

  create_table "contents", :force => true do |t|
    t.text     "summary",                            :null => false
    t.text     "content",                            :null => false
    t.boolean  "access_moove_it", :default => false
    t.boolean  "access_client",   :default => false
    t.text     "content_type",                       :null => false
    t.integer  "ranking",         :default => 3
    t.integer  "user_id",                            :null => false
    t.integer  "project_id",                         :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "contents", ["project_id"], :name => "index_contents_on_project_id"
  add_index "contents", ["user_id"], :name => "index_contents_on_user_id"

  create_table "estado_totals", :force => true do |t|
    t.string   "animo"
    t.integer  "cliente_id"
    t.integer  "proyecto_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "estado_totals", ["cliente_id"], :name => "index_estado_totals_on_cliente_id"
  add_index "estado_totals", ["proyecto_id"], :name => "index_estado_totals_on_proyecto_id"

  create_table "estados", :force => true do |t|
    t.integer  "blackboard_id"
    t.integer  "usuario_id"
    t.string   "animo"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "estados", ["blackboard_id"], :name => "index_estados_on_blackboard_id"
  add_index "estados", ["usuario_id"], :name => "index_estados_on_usuario_id"

  create_table "evaluacions", :force => true do |t|
    t.string   "tipo"
    t.integer  "hito_id"
    t.integer  "contacto_id"
    t.integer  "proyecto_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "evaluacions", ["hito_id"], :name => "index_evaluacions_on_hito_id"
  add_index "evaluacions", ["proyecto_id", "contacto_id"], :name => "index_evaluacions_on_proyecto_id_and_contacto_id"

  create_table "forms", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description", :null => false
    t.text     "admin_url",   :null => false
    t.text     "client_url",  :null => false
    t.string   "language",    :null => false
    t.date     "date",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "formularios", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion",   :limit => 1500
    t.string   "adminUrlDoc"
    t.string   "clientUrlDoc"
    t.string   "idioma"
    t.integer  "evaluacion_id"
    t.date     "fecha"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "formularios", ["evaluacion_id"], :name => "index_formularios_on_evaluacion_id"

  create_table "hitos", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion", :limit => 1000
    t.integer  "proyecto_id"
    t.date     "fecha"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "hitos", ["proyecto_id"], :name => "index_hitos_on_proyecto_id"

  create_table "milestones", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.integer  "project_id",  :null => false
    t.date     "date",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "milestones", ["project_id"], :name => "index_milestones_on_project_id"

  create_table "moods", :force => true do |t|
    t.string   "mood"
    t.string   "comment"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "moods", ["project_id"], :name => "index_moods_on_project_id"
  add_index "moods", ["user_id"], :name => "index_moods_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name",                           :null => false
    t.text     "description"
    t.integer  "client_id"
    t.boolean  "filed",       :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "proyectos", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion", :limit => 1000
    t.integer  "cliente_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "proyectos", ["cliente_id"], :name => "index_proyectos_on_cliente_id"

  create_table "set_moods", :force => true do |t|
    t.string   "set_mood_token"
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "set_moods", ["project_id"], :name => "index_set_moods_on_project_id"
  add_index "set_moods", ["user_id"], :name => "index_set_moods_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name",                                      :null => false
    t.string   "skype",                                     :null => false
    t.boolean  "is_admin",               :default => false
    t.string   "en_password",                               :null => false
    t.string   "salt",                                      :null => false
    t.string   "language",                                  :null => false
    t.string   "type"
    t.integer  "client_id"
    t.string   "identifier_url"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["client_id"], :name => "index_users_on_client_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "usuarios", :force => true do |t|
    t.string   "nick"
    t.string   "password"
    t.string   "nombre"
    t.string   "mail"
    t.string   "skype"
    t.string   "type"
    t.boolean  "admin"
    t.integer  "cliente_id"
    t.integer  "estado_id"
    t.string   "password_salt"
    t.string   "password_hash"
    t.integer  "identifier_url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "urlImagenGravatar"
  end

  add_index "usuarios", ["cliente_id"], :name => "index_usuarios_on_cliente_id"
  add_index "usuarios", ["estado_id"], :name => "index_usuarios_on_estado_id"

end
