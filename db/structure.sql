CREATE TABLE `artist_group_relationships` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `artist_id` integer NOT NULL REFERENCES `artists` ON DELETE CASCADE, `group_id` integer NOT NULL REFERENCES `groups` ON DELETE CASCADE, `type` varchar(255) NOT NULL, UNIQUE (`artist_id`, `group_id`, `type`));
CREATE TABLE `artist_library_item_relationships` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `artist_id` integer NOT NULL REFERENCES `artists` ON DELETE CASCADE, `library_item_id` integer NOT NULL, `type` varchar(255) NOT NULL, UNIQUE (`artist_id`, `library_item_id`, `type`));
CREATE TABLE `artists` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `what_id` integer UNIQUE, `what_name` varchar(255), `created_at` timestamp NOT NULL, `updated_at` timestamp);
CREATE TABLE `groups` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `library_album_id` integer NOT NULL UNIQUE, `what_id` integer UNIQUE, `what_artist` varchar(255), `what_name` varchar(255), `what_tags` varchar(255), `what_year` integer, `what_release_type` varchar(255), `what_artists` varchar(255), `what_record_label` varchar(255), `what_catalog_number` varchar(255), `what_confidence` double precision, `created_at` timestamp NOT NULL, `updated_at` timestamp);
CREATE TABLE `schema_migrations` (`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `what_api_info` (`last_request` timestamp, `cookie` varchar(255));
CREATE INDEX `artist_group_relationships_artist_id_group_id_index` ON `artist_group_relationships` (`artist_id`, `group_id`);
CREATE INDEX `artist_group_relationships_group_id_index` ON `artist_group_relationships` (`group_id`);
CREATE INDEX `artist_library_item_relationships_artist_id_library_item_id_index` ON `artist_library_item_relationships` (`artist_id`, `library_item_id`);
CREATE INDEX `artist_library_item_relationships_library_item_id_index` ON `artist_library_item_relationships` (`library_item_id`);
CREATE INDEX `groups_library_album_id_index` ON `groups` (`library_album_id`);
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140308023547_create_groups.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311194900_create_artists.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311195146_create_artist_group_relationships.rb');
INSERT INTO `schema_migrations` (`filename`) VALUES ('20140312012119_create_artist_library_item_relationships.rb');