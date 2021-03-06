CREATE TABLE `artist_group_relationships` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `artist_id` integer NOT NULL REFERENCES `artists` ON DELETE CASCADE, `group_id` integer NOT NULL REFERENCES `groups` ON DELETE CASCADE, `type` varchar(255) NOT NULL, UNIQUE (`artist_id`, `group_id`, `type`));
CREATE TABLE `artist_library_item_relationships` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `artist_id` integer NOT NULL REFERENCES `artists` ON DELETE CASCADE, `library_item_id` integer NOT NULL, `type` varchar(255) NOT NULL, `group_artist` boolean DEFAULT (0) NOT NULL, `confidence` double precision NOT NULL, UNIQUE (`artist_id`, `library_item_id`, `type`, `group_artist`));
CREATE TABLE `artists` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `whatcd_id` integer UNIQUE, `whatcd_name` varchar(255), `whatcd_updated_at` timestamp, `created_at` timestamp NOT NULL, `updated_at` timestamp);
CREATE TABLE `groups` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `library_album_id` integer NOT NULL UNIQUE, `whatcd_id` integer, `whatcd_name` varchar(255), `whatcd_tags` varchar(255), `whatcd_year` integer, `whatcd_artists` varchar(255), `whatcd_record_label` varchar(255), `whatcd_catalog_number` varchar(255), `whatcd_release_type_id` integer REFERENCES `whatcd_release_types`, `whatcd_confidence` double precision, `whatcd_updated_at` timestamp, `created_at` timestamp NOT NULL, `updated_at` timestamp);
CREATE TABLE `library_item_playbacks` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `library_item_id` integer NOT NULL, `playback_started_at` timestamp NOT NULL);
CREATE TABLE `playlist_initial_artist_relationships` (`initial_artist_id` integer NOT NULL REFERENCES `artists`, `playlist_id` integer NOT NULL REFERENCES `playlists`, PRIMARY KEY (`initial_artist_id`, `playlist_id`));
CREATE TABLE `playlist_items` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `playlist_id` integer NOT NULL REFERENCES `playlists`, `library_item_id` integer NOT NULL, `position` integer NOT NULL, `created_at` timestamp NOT NULL);
CREATE TABLE `playlists`(`id` integer DEFAULT (NULL) NOT NULL PRIMARY KEY, `created_at` timestamp DEFAULT (NULL) NOT NULL, `current_position` integer);
CREATE TABLE `schema_info` (`version` integer DEFAULT (0) NOT NULL);
CREATE TABLE `schema_migrations` (`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `similar_artists_relationships` (`artist_id` integer NOT NULL REFERENCES `artists`, `similar_artist_id` integer NOT NULL REFERENCES `artists`, `whatcd_score` integer NOT NULL, PRIMARY KEY (`artist_id`, `similar_artist_id`));
CREATE TABLE `whatcd_api_info` (`last_request` timestamp, `cookie` varchar(255));
CREATE TABLE "whatcd_artist_responses" (`id` integer NOT NULL PRIMARY KEY, `response` varchar(255) NOT NULL, `updated_at` timestamp NOT NULL);
CREATE TABLE "whatcd_release_types" (`id` integer NOT NULL PRIMARY KEY, `name` varchar(255) NOT NULL);
CREATE TABLE `whatcd_similar_artists_responses` (`id` integer NOT NULL PRIMARY KEY, `response` varchar(255) NOT NULL, `updated_at` timestamp NOT NULL);
CREATE TABLE "whatcd_torrent_group_responses" (`id` integer NOT NULL PRIMARY KEY, `response` varchar(255) NOT NULL, `updated_at` timestamp NOT NULL);
CREATE INDEX `artist_group_relationships_artist_id_group_id_index` ON `artist_group_relationships` (`artist_id`, `group_id`);
CREATE INDEX `artist_group_relationships_group_id_index` ON `artist_group_relationships` (`group_id`);
CREATE INDEX `artist_library_item_relationships_artist_id_library_item_id_index` ON `artist_library_item_relationships` (`artist_id`, `library_item_id`);
CREATE INDEX `artist_library_item_relationships_library_item_id_index` ON `artist_library_item_relationships` (`library_item_id`);
CREATE INDEX `artists_whatcd_id_index` ON `artists` (`whatcd_id`);
CREATE INDEX `groups_library_album_id_index` ON `groups` (`library_album_id`);
CREATE INDEX `library_item_playbacks_library_item_id_index` ON `library_item_playbacks` (`library_item_id`);
CREATE INDEX `playlist_initial_artist_relationships_playlist_id_index` ON `playlist_initial_artist_relationships` (`playlist_id`);
CREATE UNIQUE INDEX `playlist_items_playlist_id_position_index` ON `playlist_items` (`playlist_id`, `position`);
CREATE INDEX `similar_artists_relationships_similar_artist_id_index` ON `similar_artists_relationships` (`similar_artist_id`);
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140308023547_create_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311194900_create_artists.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311195146_create_artist_group_relationships.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140312012119_create_artist_library_item_relationships.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140320180803_create_what_api_result_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140320180813_create_what_api_torrent_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324193545_drop_what_api_result_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324200142_create_what_cd_torrent_group_responses.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324201727_create_what_cd_artist_responses.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324202010_drop_api_info_tables.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324220924_remove_what_artist_from_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324223644_create_what_cd_release_types.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140324223909_change_group_what_release_type_to_what_release_type_id.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325175651_create_similar_artists_relationships.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325183937_rename_what_cd_to_whatcd.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325185409_rename_groups_what_columns.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325192503_rename_artists_what_columns.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325194809_rename_table_references.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325230343_add_index_to_artists_what_id.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140325234005_create_whatcd_similar_artists_responses.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140403221014_create_playlists.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140416204619_create_playlist_items.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140429185858_add_current_position_to_playlists.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140430171348_create_artists_playlists.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140430210719_create_library_item_playbacks.rb');