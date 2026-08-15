--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS public;


--
-- Name: COLLATION_UNICODE_1; Type: COLLATION; Schema: public; Owner: -
--

CREATE COLLATION public."COLLATION_UNICODE_1" (provider = icu, deterministic = false, locale = 'und-u-ks-level1');


--
-- Name: COLLATION_UNICODE_3; Type: COLLATION; Schema: public; Owner: -
--

CREATE COLLATION public."COLLATION_UNICODE_3" (provider = icu, deterministic = false, locale = 'und-u-ks-level3');


--
-- Name: NOCASE; Type: COLLATION; Schema: public; Owner: -
--

CREATE COLLATION public."NOCASE" (provider = icu, deterministic = false, locale = 'und-u-ks-level2');


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: announcements_read; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements_read (
    "USER_ID" text NOT NULL,
    "ANNOUNCEMENT_ID" text NOT NULL
);


--
-- Name: authentication_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_activity (
    "USER_ID" text,
    "EMAIL" text,
    "IP" text,
    "USER_AGENT" text,
    "SUCCESS" boolean NOT NULL,
    "ERROR" text,
    "DATE_TIME" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "SOURCE" text,
    "API_KEY_ID" text,
    "API_KEY_COMMENT" text
);


--
-- Name: book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book (
    "ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "FILE_LAST_MODIFIED" timestamp without time zone NOT NULL,
    "NAME" text NOT NULL,
    "URL" text NOT NULL,
    "SERIES_ID" text NOT NULL,
    "FILE_SIZE" bigint DEFAULT 0 NOT NULL,
    "NUMBER" integer DEFAULT 0 NOT NULL,
    "LIBRARY_ID" text NOT NULL,
    "FILE_HASH" text NOT NULL,
    "DELETED_DATE" timestamp without time zone,
    oneshot boolean DEFAULT false NOT NULL,
    "FILE_HASH_KOREADER" text NOT NULL
);


--
-- Name: book_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata (
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "NUMBER" text NOT NULL,
    "NUMBER_LOCK" boolean DEFAULT false NOT NULL,
    "NUMBER_SORT" real NOT NULL,
    "NUMBER_SORT_LOCK" boolean DEFAULT false NOT NULL,
    "RELEASE_DATE" date,
    "RELEASE_DATE_LOCK" boolean DEFAULT false NOT NULL,
    "SUMMARY" text NOT NULL,
    "SUMMARY_LOCK" boolean DEFAULT false NOT NULL,
    "TITLE" text NOT NULL,
    "TITLE_LOCK" boolean DEFAULT false NOT NULL,
    "AUTHORS_LOCK" boolean DEFAULT false NOT NULL,
    "TAGS_LOCK" boolean DEFAULT false NOT NULL,
    "BOOK_ID" text NOT NULL,
    "ISBN" text NOT NULL,
    "ISBN_LOCK" boolean DEFAULT false NOT NULL,
    "LINKS_LOCK" boolean DEFAULT false NOT NULL
);


--
-- Name: book_metadata_aggregation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_aggregation (
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "RELEASE_DATE" date,
    "SUMMARY" text NOT NULL,
    "SUMMARY_NUMBER" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: book_metadata_aggregation_author; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_aggregation_author (
    "NAME" text NOT NULL,
    "ROLE" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: book_metadata_aggregation_tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_aggregation_tag (
    "TAG" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: book_metadata_author; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_author (
    "NAME" text NOT NULL,
    "ROLE" text NOT NULL,
    "BOOK_ID" text NOT NULL
);


--
-- Name: book_metadata_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_link (
    "LABEL" text NOT NULL,
    "URL" text NOT NULL,
    "BOOK_ID" text NOT NULL
);


--
-- Name: book_metadata_tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_metadata_tag (
    "TAG" text NOT NULL,
    "BOOK_ID" text NOT NULL
);


--
-- Name: client_settings_global; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_settings_global (
    "KEY" text NOT NULL,
    "VALUE" text NOT NULL,
    "ALLOW_UNAUTHORIZED" boolean DEFAULT false NOT NULL
);


--
-- Name: client_settings_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_settings_user (
    "USER_ID" text NOT NULL,
    "KEY" text NOT NULL,
    "VALUE" text NOT NULL
);


--
-- Name: collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection (
    "ID" text NOT NULL,
    "NAME" text NOT NULL,
    "ORDERED" boolean DEFAULT false NOT NULL,
    "SERIES_COUNT" integer NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: collection_series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection_series (
    "COLLECTION_ID" text NOT NULL,
    "SERIES_ID" text NOT NULL,
    "NUMBER" integer NOT NULL
);


--
-- Name: historical_event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historical_event (
    "ID" text NOT NULL,
    "TYPE" text NOT NULL,
    "BOOK_ID" text,
    "SERIES_ID" text,
    "TIMESTAMP" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: historical_event_properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historical_event_properties (
    "ID" text NOT NULL,
    "KEY" text NOT NULL,
    "VALUE" text NOT NULL
);


--
-- Name: library; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.library (
    "ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "NAME" text NOT NULL,
    "ROOT" text NOT NULL,
    "IMPORT_COMICINFO_BOOK" boolean DEFAULT true NOT NULL,
    "IMPORT_COMICINFO_SERIES" boolean DEFAULT true NOT NULL,
    "IMPORT_COMICINFO_COLLECTION" boolean DEFAULT true NOT NULL,
    "IMPORT_EPUB_BOOK" boolean DEFAULT true NOT NULL,
    "IMPORT_EPUB_SERIES" boolean DEFAULT true NOT NULL,
    "SCAN_FORCE_MODIFIED_TIME" boolean DEFAULT false NOT NULL,
    "SCAN_STARTUP" boolean DEFAULT ${library-scan-startup} NOT NULL,
    "IMPORT_LOCAL_ARTWORK" boolean DEFAULT true NOT NULL,
    "IMPORT_COMICINFO_READLIST" boolean DEFAULT true NOT NULL,
    "IMPORT_BARCODE_ISBN" boolean DEFAULT true NOT NULL,
    "CONVERT_TO_CBZ" boolean DEFAULT false NOT NULL,
    "REPAIR_EXTENSIONS" boolean DEFAULT false NOT NULL,
    "EMPTY_TRASH_AFTER_SCAN" boolean DEFAULT false NOT NULL,
    "IMPORT_MYLAR_SERIES" boolean DEFAULT true NOT NULL,
    "SERIES_COVER" text DEFAULT 'FIRST'::text NOT NULL,
    "UNAVAILABLE_DATE" timestamp without time zone,
    "HASH_FILES" boolean DEFAULT ${library-file-hashing} NOT NULL,
    "HASH_PAGES" boolean DEFAULT false NOT NULL,
    "ANALYZE_DIMENSIONS" boolean DEFAULT true NOT NULL,
    "IMPORT_COMICINFO_SERIES_APPEND_VOLUME" boolean DEFAULT true NOT NULL,
    "ONESHOTS_DIRECTORY" text,
    "SCAN_CBX" boolean DEFAULT true NOT NULL,
    "SCAN_PDF" boolean DEFAULT true NOT NULL,
    "SCAN_EPUB" boolean DEFAULT true NOT NULL,
    "SCAN_INTERVAL" text DEFAULT 'EVERY_6H'::text NOT NULL,
    "HASH_KOREADER" boolean DEFAULT false NOT NULL
);


--
-- Name: library_exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.library_exclusions (
    "LIBRARY_ID" text NOT NULL,
    "EXCLUSION" text NOT NULL
);


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    "MEDIA_TYPE" text,
    "STATUS" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "COMMENT" text,
    "BOOK_ID" text NOT NULL,
    "PAGE_COUNT" integer DEFAULT 0 NOT NULL,
    "EXTENSION_CLASS" text,
    "_UNUSED" text,
    "EXTENSION_VALUE_BLOB" bytea,
    "EPUB_DIVINA_COMPATIBLE" boolean DEFAULT false NOT NULL,
    "EPUB_IS_KEPUB" boolean DEFAULT false NOT NULL
);


--
-- Name: media_file; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_file (
    "FILE_NAME" text NOT NULL,
    "BOOK_ID" text NOT NULL,
    "MEDIA_TYPE" text,
    "SUB_TYPE" text,
    "FILE_SIZE" bigint
);


--
-- Name: media_page; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_page (
    "FILE_NAME" text NOT NULL,
    "MEDIA_TYPE" text NOT NULL,
    "NUMBER" integer NOT NULL,
    "BOOK_ID" text NOT NULL,
    width integer,
    height integer,
    "FILE_HASH" text NOT NULL,
    "FILE_SIZE" bigint
);


--
-- Name: page_hash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_hash (
    "HASH" text NOT NULL,
    "SIZE" bigint,
    "ACTION" text NOT NULL,
    "DELETE_COUNT" integer DEFAULT 0 NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: page_hash_thumbnail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_hash_thumbnail (
    "HASH" text NOT NULL,
    "THUMBNAIL" bytea NOT NULL
);


--
-- Name: read_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.read_progress (
    "BOOK_ID" text NOT NULL,
    "USER_ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "PAGE" integer NOT NULL,
    "COMPLETED" boolean NOT NULL,
    "READ_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    device_id text,
    device_name text,
    locator bytea
);


--
-- Name: read_progress_series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.read_progress_series (
    "SERIES_ID" text NOT NULL,
    "USER_ID" text NOT NULL,
    "READ_COUNT" integer NOT NULL,
    "IN_PROGRESS_COUNT" integer NOT NULL,
    "MOST_RECENT_READ_DATE" timestamp without time zone,
    "LAST_MODIFIED_DATE" timestamp without time zone
);


--
-- Name: readlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.readlist (
    "ID" text NOT NULL,
    "NAME" text NOT NULL,
    "BOOK_COUNT" integer NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "SUMMARY" text NOT NULL,
    "ORDERED" boolean DEFAULT true NOT NULL
);


--
-- Name: readlist_book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.readlist_book (
    "READLIST_ID" text NOT NULL,
    "BOOK_ID" text NOT NULL,
    "NUMBER" integer NOT NULL
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series (
    "ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "FILE_LAST_MODIFIED" timestamp without time zone NOT NULL,
    "NAME" text NOT NULL,
    "URL" text NOT NULL,
    "LIBRARY_ID" text NOT NULL,
    "BOOK_COUNT" integer DEFAULT 0 NOT NULL,
    "DELETED_DATE" timestamp without time zone,
    oneshot boolean DEFAULT false NOT NULL
);


--
-- Name: series_metadata_tag; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata_tag (
    "TAG" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: series_and_book_tag; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.series_and_book_tag AS
 SELECT bmat."TAG",
    bmat."SERIES_ID"
   FROM public.book_metadata_aggregation_tag bmat
UNION ALL
 SELECT smt."TAG",
    smt."SERIES_ID"
   FROM public.series_metadata_tag smt;


--
-- Name: series_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata (
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "STATUS" text NOT NULL,
    "STATUS_LOCK" boolean DEFAULT false NOT NULL,
    "TITLE" text NOT NULL,
    "TITLE_LOCK" boolean DEFAULT false NOT NULL,
    "TITLE_SORT" text NOT NULL,
    "TITLE_SORT_LOCK" boolean DEFAULT false NOT NULL,
    "SERIES_ID" text NOT NULL,
    "PUBLISHER" text NOT NULL,
    "PUBLISHER_LOCK" boolean DEFAULT false NOT NULL,
    "READING_DIRECTION" text,
    "READING_DIRECTION_LOCK" boolean DEFAULT false NOT NULL,
    "AGE_RATING" integer,
    "AGE_RATING_LOCK" boolean DEFAULT false NOT NULL,
    "SUMMARY" text NOT NULL,
    "SUMMARY_LOCK" boolean DEFAULT false NOT NULL,
    "LANGUAGE" text NOT NULL,
    "LANGUAGE_LOCK" boolean DEFAULT false NOT NULL,
    "GENRES_LOCK" boolean DEFAULT false NOT NULL,
    "TAGS_LOCK" boolean DEFAULT false NOT NULL,
    "TOTAL_BOOK_COUNT" integer,
    "TOTAL_BOOK_COUNT_LOCK" boolean DEFAULT false NOT NULL,
    "SHARING_LABELS_LOCK" boolean DEFAULT false NOT NULL,
    "LINKS_LOCK" boolean DEFAULT false NOT NULL,
    "ALTERNATE_TITLES_LOCK" boolean DEFAULT false NOT NULL
);


--
-- Name: series_metadata_alternate_title; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata_alternate_title (
    "LABEL" text NOT NULL,
    "TITLE" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: series_metadata_genre; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata_genre (
    "GENRE" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: series_metadata_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata_link (
    "LABEL" text NOT NULL,
    "URL" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: series_metadata_sharing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_metadata_sharing (
    "LABEL" text NOT NULL,
    "SERIES_ID" text NOT NULL
);


--
-- Name: server_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.server_settings (
    "KEY" text NOT NULL,
    "VALUE" text
);


--
-- Data for Name: server_settings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.server_settings VALUES ('DELETE_EMPTY_COLLECTIONS', ${delete-empty-collections});
INSERT INTO public.server_settings VALUES ('DELETE_EMPTY_READLISTS', ${delete-empty-read-lists});
INSERT INTO public.server_settings VALUES ('REMEMBER_ME_KEY', upper(encode(public.gen_random_bytes(32), 'hex')));
INSERT INTO public.server_settings VALUES ('REMEMBER_ME_DURATION', '365');


--
-- Name: sidecar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sidecar (
    "URL" text NOT NULL,
    "PARENT_URL" text NOT NULL,
    "LAST_MODIFIED_TIME" timestamp without time zone NOT NULL,
    "LIBRARY_ID" text NOT NULL
);


--
-- Name: sync_point; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point (
    "ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "USER_ID" text NOT NULL,
    "API_KEY_ID" text
);


--
-- Name: sync_point_book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point_book (
    "SYNC_POINT_ID" text NOT NULL,
    "BOOK_ID" text NOT NULL,
    "BOOK_CREATED_DATE" timestamp without time zone NOT NULL,
    "BOOK_LAST_MODIFIED_DATE" timestamp without time zone NOT NULL,
    "BOOK_FILE_LAST_MODIFIED" timestamp without time zone NOT NULL,
    "BOOK_FILE_SIZE" bigint NOT NULL,
    "BOOK_FILE_HASH" text NOT NULL,
    "BOOK_METADATA_LAST_MODIFIED_DATE" timestamp without time zone NOT NULL,
    "BOOK_READ_PROGRESS_LAST_MODIFIED_DATE" timestamp without time zone,
    "SYNCED" boolean DEFAULT true NOT NULL,
    "BOOK_THUMBNAIL_ID" text
);


--
-- Name: sync_point_book_removed_synced; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point_book_removed_synced (
    "SYNC_POINT_ID" text NOT NULL,
    "BOOK_ID" text NOT NULL
);


--
-- Name: sync_point_readlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point_readlist (
    "SYNC_POINT_ID" text NOT NULL,
    "READLIST_ID" text NOT NULL,
    "READLIST_NAME" text NOT NULL,
    "READLIST_CREATED_DATE" timestamp without time zone NOT NULL,
    "READLIST_LAST_MODIFIED_DATE" timestamp without time zone NOT NULL,
    "SYNCED" boolean DEFAULT true NOT NULL
);


--
-- Name: sync_point_readlist_book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point_readlist_book (
    "SYNC_POINT_ID" text NOT NULL,
    "READLIST_ID" text NOT NULL,
    "BOOK_ID" text NOT NULL
);


--
-- Name: sync_point_readlist_removed_synced; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_point_readlist_removed_synced (
    "SYNC_POINT_ID" text NOT NULL,
    "READLIST_ID" text NOT NULL
);


--
-- Name: thumbnail_book; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thumbnail_book (
    "ID" text NOT NULL,
    "THUMBNAIL" bytea,
    "URL" text,
    "SELECTED" boolean DEFAULT false NOT NULL,
    "TYPE" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "BOOK_ID" text NOT NULL,
    "WIDTH" integer DEFAULT 0 NOT NULL,
    "HEIGHT" integer DEFAULT 0 NOT NULL,
    "MEDIA_TYPE" text NOT NULL,
    "FILE_SIZE" bigint DEFAULT 0 NOT NULL
);


--
-- Name: thumbnail_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thumbnail_collection (
    "ID" text NOT NULL,
    "SELECTED" boolean DEFAULT false NOT NULL,
    "THUMBNAIL" bytea NOT NULL,
    "TYPE" text NOT NULL,
    "COLLECTION_ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "WIDTH" integer DEFAULT 0 NOT NULL,
    "HEIGHT" integer DEFAULT 0 NOT NULL,
    "MEDIA_TYPE" text NOT NULL,
    "FILE_SIZE" bigint DEFAULT 0 NOT NULL
);


--
-- Name: thumbnail_readlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thumbnail_readlist (
    "ID" text NOT NULL,
    "SELECTED" boolean DEFAULT false NOT NULL,
    "THUMBNAIL" bytea NOT NULL,
    "TYPE" text NOT NULL,
    "READLIST_ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "WIDTH" integer DEFAULT 0 NOT NULL,
    "HEIGHT" integer DEFAULT 0 NOT NULL,
    "MEDIA_TYPE" text NOT NULL,
    "FILE_SIZE" bigint DEFAULT 0 NOT NULL
);


--
-- Name: thumbnail_series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thumbnail_series (
    "ID" text NOT NULL,
    "URL" text,
    "SELECTED" boolean DEFAULT false NOT NULL,
    "THUMBNAIL" bytea,
    "TYPE" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "SERIES_ID" text NOT NULL,
    "WIDTH" integer DEFAULT 0 NOT NULL,
    "HEIGHT" integer DEFAULT 0 NOT NULL,
    "MEDIA_TYPE" text NOT NULL,
    "FILE_SIZE" bigint DEFAULT 0 NOT NULL
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    "ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "EMAIL" text NOT NULL,
    "PASSWORD" text NOT NULL,
    "SHARED_ALL_LIBRARIES" boolean DEFAULT true NOT NULL,
    "AGE_RESTRICTION" integer,
    "AGE_RESTRICTION_ALLOW_ONLY" boolean
);


--
-- Name: user_api_key; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_api_key (
    "ID" text NOT NULL,
    "USER_ID" text NOT NULL,
    "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "API_KEY" text NOT NULL,
    "COMMENT" text NOT NULL
);


--
-- Name: user_library_sharing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_library_sharing (
    "USER_ID" text NOT NULL,
    "LIBRARY_ID" text NOT NULL
);


--
-- Name: user_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_role (
    "USER_ID" text NOT NULL,
    "ROLE" text NOT NULL
);


--
-- Name: user_sharing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sharing (
    "LABEL" text NOT NULL,
    "ALLOW" boolean NOT NULL,
    "USER_ID" text NOT NULL
);


--
-- Name: announcements_read idx_241786_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements_read
    ADD CONSTRAINT "idx_241786_PRIMARY" PRIMARY KEY ("USER_ID", "ANNOUNCEMENT_ID");


--
-- Name: book idx_241801_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT "idx_241801_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: book_metadata idx_241824_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata
    ADD CONSTRAINT "idx_241824_PRIMARY" PRIMARY KEY ("BOOK_ID");


--
-- Name: book_metadata_aggregation idx_241857_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_aggregation
    ADD CONSTRAINT "idx_241857_PRIMARY" PRIMARY KEY ("SERIES_ID");


--
-- Name: client_settings_global idx_241907_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_settings_global
    ADD CONSTRAINT "idx_241907_PRIMARY" PRIMARY KEY ("KEY");


--
-- Name: client_settings_user idx_241916_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_settings_user
    ADD CONSTRAINT "idx_241916_PRIMARY" PRIMARY KEY ("USER_ID", "KEY");


--
-- Name: collection idx_241924_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT "idx_241924_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: collection_series idx_241938_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_series
    ADD CONSTRAINT "idx_241938_PRIMARY" PRIMARY KEY ("COLLECTION_ID", "SERIES_ID");


--
-- Name: historical_event idx_241946_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_event
    ADD CONSTRAINT "idx_241946_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: historical_event_properties idx_241954_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_event_properties
    ADD CONSTRAINT "idx_241954_PRIMARY" PRIMARY KEY ("ID", "KEY");


--
-- Name: library idx_241962_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.library
    ADD CONSTRAINT "idx_241962_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: library_exclusions idx_242022_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.library_exclusions
    ADD CONSTRAINT "idx_242022_PRIMARY" PRIMARY KEY ("LIBRARY_ID", "EXCLUSION");


--
-- Name: media idx_242029_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT "idx_242029_PRIMARY" PRIMARY KEY ("BOOK_ID");


--
-- Name: media_page idx_242053_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_page
    ADD CONSTRAINT "idx_242053_PRIMARY" PRIMARY KEY ("NUMBER", "BOOK_ID");


--
-- Name: page_hash idx_242063_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_hash
    ADD CONSTRAINT "idx_242063_PRIMARY" PRIMARY KEY ("HASH");


--
-- Name: page_hash_thumbnail idx_242076_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_hash_thumbnail
    ADD CONSTRAINT "idx_242076_PRIMARY" PRIMARY KEY ("HASH");


--
-- Name: read_progress idx_242083_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress
    ADD CONSTRAINT "idx_242083_PRIMARY" PRIMARY KEY ("BOOK_ID", "USER_ID");


--
-- Name: read_progress_series idx_242097_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress_series
    ADD CONSTRAINT "idx_242097_PRIMARY" PRIMARY KEY ("SERIES_ID", "USER_ID");


--
-- Name: readlist idx_242106_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readlist
    ADD CONSTRAINT "idx_242106_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: readlist_book idx_242121_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readlist_book
    ADD CONSTRAINT "idx_242121_PRIMARY" PRIMARY KEY ("READLIST_ID", "BOOK_ID");


--
-- Name: series idx_242129_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT "idx_242129_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: series_metadata idx_242147_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata
    ADD CONSTRAINT "idx_242147_PRIMARY" PRIMARY KEY ("SERIES_ID");


--
-- Name: server_settings idx_242228_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_settings
    ADD CONSTRAINT "idx_242228_PRIMARY" PRIMARY KEY ("KEY");


--
-- Name: sidecar idx_242234_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sidecar
    ADD CONSTRAINT "idx_242234_PRIMARY" PRIMARY KEY ("URL");


--
-- Name: sync_point idx_242243_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point
    ADD CONSTRAINT "idx_242243_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: sync_point_book idx_242252_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_book
    ADD CONSTRAINT "idx_242252_PRIMARY" PRIMARY KEY ("SYNC_POINT_ID", "BOOK_ID");


--
-- Name: sync_point_book_removed_synced idx_242267_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_book_removed_synced
    ADD CONSTRAINT "idx_242267_PRIMARY" PRIMARY KEY ("SYNC_POINT_ID", "BOOK_ID");


--
-- Name: sync_point_readlist idx_242274_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist
    ADD CONSTRAINT "idx_242274_PRIMARY" PRIMARY KEY ("SYNC_POINT_ID", "READLIST_ID");


--
-- Name: sync_point_readlist_book idx_242286_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist_book
    ADD CONSTRAINT "idx_242286_PRIMARY" PRIMARY KEY ("SYNC_POINT_ID", "READLIST_ID", "BOOK_ID");


--
-- Name: sync_point_readlist_removed_synced idx_242294_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist_removed_synced
    ADD CONSTRAINT "idx_242294_PRIMARY" PRIMARY KEY ("SYNC_POINT_ID", "READLIST_ID");


--
-- Name: thumbnail_book idx_242301_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_book
    ADD CONSTRAINT "idx_242301_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: thumbnail_collection idx_242322_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_collection
    ADD CONSTRAINT "idx_242322_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: thumbnail_readlist idx_242344_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_readlist
    ADD CONSTRAINT "idx_242344_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: thumbnail_series idx_242366_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_series
    ADD CONSTRAINT "idx_242366_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: user idx_242387_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "idx_242387_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: user_api_key idx_242401_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_api_key
    ADD CONSTRAINT "idx_242401_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: user_library_sharing idx_242414_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_library_sharing
    ADD CONSTRAINT "idx_242414_PRIMARY" PRIMARY KEY ("USER_ID", "LIBRARY_ID");


--
-- Name: user_role idx_242421_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT "idx_242421_PRIMARY" PRIMARY KEY ("USER_ID", "ROLE");


--
-- Name: user_sharing idx_242428_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sharing
    ADD CONSTRAINT "idx_242428_PRIMARY" PRIMARY KEY ("LABEL", "ALLOW", "USER_ID");


--
-- Name: idx_241786_sqlite_autoindex_ANNOUNCEMENTS_READ_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241786_sqlite_autoindex_ANNOUNCEMENTS_READ_1" ON public.announcements_read USING btree ("USER_ID", "ANNOUNCEMENT_ID");


--
-- Name: idx_241793_idx__authentication_activity__user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241793_idx__authentication_activity__user_id ON public.authentication_activity USING btree ("USER_ID");


--
-- Name: idx_241801_idx__book__created_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241801_idx__book__created_date ON public.book USING btree ("CREATED_DATE");


--
-- Name: idx_241801_idx__book__library_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241801_idx__book__library_id ON public.book USING btree ("LIBRARY_ID");


--
-- Name: idx_241801_idx__book__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241801_idx__book__series_id ON public.book USING btree ("SERIES_ID");


--
-- Name: idx_241801_sqlite_autoindex_BOOK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241801_sqlite_autoindex_BOOK_1" ON public.book USING btree ("ID");


--
-- Name: idx_241824_idx__book_metadata__number_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241824_idx__book_metadata__number_sort ON public.book_metadata USING btree ("NUMBER_SORT");


--
-- Name: idx_241824_idx__book_metadata__release_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241824_idx__book_metadata__release_date ON public.book_metadata USING btree ("RELEASE_DATE");


--
-- Name: idx_241824_sqlite_autoindex_BOOK_METADATA_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241824_sqlite_autoindex_BOOK_METADATA_1" ON public.book_metadata USING btree ("BOOK_ID");


--
-- Name: idx_241857_sqlite_autoindex_BOOK_METADATA_AGGREGATION_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241857_sqlite_autoindex_BOOK_METADATA_AGGREGATION_1" ON public.book_metadata_aggregation USING btree ("SERIES_ID");


--
-- Name: idx_241869_idx__book_metadata_aggregation_author__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241869_idx__book_metadata_aggregation_author__series_id ON public.book_metadata_aggregation_author USING btree ("SERIES_ID");


--
-- Name: idx_241877_idx__book_metadata_aggregation_tag__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241877_idx__book_metadata_aggregation_tag__series_id ON public.book_metadata_aggregation_tag USING btree ("SERIES_ID");


--
-- Name: idx_241884_idx__book_metadata_author__book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241884_idx__book_metadata_author__book_id ON public.book_metadata_author USING btree ("BOOK_ID");


--
-- Name: idx_241892_idx__book_metadata_link__book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241892_idx__book_metadata_link__book_id ON public.book_metadata_link USING btree ("BOOK_ID");


--
-- Name: idx_241900_idx__book_metadata_tag__book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_241900_idx__book_metadata_tag__book_id ON public.book_metadata_tag USING btree ("BOOK_ID");


--
-- Name: idx_241907_sqlite_autoindex_CLIENT_SETTINGS_GLOBAL_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241907_sqlite_autoindex_CLIENT_SETTINGS_GLOBAL_1" ON public.client_settings_global USING btree ("KEY");


--
-- Name: idx_241916_sqlite_autoindex_CLIENT_SETTINGS_USER_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241916_sqlite_autoindex_CLIENT_SETTINGS_USER_1" ON public.client_settings_user USING btree ("KEY", "USER_ID");


--
-- Name: idx_241924_sqlite_autoindex_COLLECTION_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241924_sqlite_autoindex_COLLECTION_1" ON public.collection USING btree ("ID");


--
-- Name: idx_241938_sqlite_autoindex_COLLECTION_SERIES_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241938_sqlite_autoindex_COLLECTION_SERIES_1" ON public.collection_series USING btree ("COLLECTION_ID", "SERIES_ID");


--
-- Name: idx_241946_sqlite_autoindex_HISTORICAL_EVENT_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241946_sqlite_autoindex_HISTORICAL_EVENT_1" ON public.historical_event USING btree ("ID");


--
-- Name: idx_241954_sqlite_autoindex_HISTORICAL_EVENT_PROPERTIES_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241954_sqlite_autoindex_HISTORICAL_EVENT_PROPERTIES_1" ON public.historical_event_properties USING btree ("ID", "KEY");


--
-- Name: idx_241962_sqlite_autoindex_LIBRARY_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_241962_sqlite_autoindex_LIBRARY_1" ON public.library USING btree ("ID");


--
-- Name: idx_242022_idx__library_exclusions__library_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242022_idx__library_exclusions__library_id ON public.library_exclusions USING btree ("LIBRARY_ID");


--
-- Name: idx_242022_sqlite_autoindex_LIBRARY_EXCLUSIONS_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242022_sqlite_autoindex_LIBRARY_EXCLUSIONS_1" ON public.library_exclusions USING btree ("LIBRARY_ID", "EXCLUSION");


--
-- Name: idx_242029_idx__media__status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242029_idx__media__status ON public.media USING btree ("STATUS");


--
-- Name: idx_242029_sqlite_autoindex_MEDIA_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242029_sqlite_autoindex_MEDIA_1" ON public.media USING btree ("BOOK_ID");


--
-- Name: idx_242046_idx__media_file__book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242046_idx__media_file__book_id ON public.media_file USING btree ("BOOK_ID");


--
-- Name: idx_242053_sqlite_autoindex_MEDIA_PAGE_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242053_sqlite_autoindex_MEDIA_PAGE_1" ON public.media_page USING btree ("BOOK_ID", "NUMBER");


--
-- Name: idx_242063_sqlite_autoindex_PAGE_HASH_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242063_sqlite_autoindex_PAGE_HASH_1" ON public.page_hash USING btree ("HASH");


--
-- Name: idx_242076_sqlite_autoindex_PAGE_HASH_THUMBNAIL_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242076_sqlite_autoindex_PAGE_HASH_THUMBNAIL_1" ON public.page_hash_thumbnail USING btree ("HASH");


--
-- Name: idx_242083_idx__read_progress__last_modified_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242083_idx__read_progress__last_modified_date ON public.read_progress USING btree ("LAST_MODIFIED_DATE");


--
-- Name: idx_242083_sqlite_autoindex_READ_PROGRESS_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242083_sqlite_autoindex_READ_PROGRESS_1" ON public.read_progress USING btree ("BOOK_ID", "USER_ID");


--
-- Name: idx_242097_sqlite_autoindex_READ_PROGRESS_SERIES_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242097_sqlite_autoindex_READ_PROGRESS_SERIES_1" ON public.read_progress_series USING btree ("SERIES_ID", "USER_ID");


--
-- Name: idx_242106_sqlite_autoindex_READLIST_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242106_sqlite_autoindex_READLIST_1" ON public.readlist USING btree ("ID");


--
-- Name: idx_242121_sqlite_autoindex_READLIST_BOOK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242121_sqlite_autoindex_READLIST_BOOK_1" ON public.readlist_book USING btree ("READLIST_ID", "BOOK_ID");


--
-- Name: idx_242129_idx__series__created_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242129_idx__series__created_date ON public.series USING btree ("CREATED_DATE");


--
-- Name: idx_242129_idx__series__last_modified_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242129_idx__series__last_modified_date ON public.series USING btree ("LAST_MODIFIED_DATE");


--
-- Name: idx_242129_idx__series__library_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242129_idx__series__library_id ON public.series USING btree ("LIBRARY_ID");


--
-- Name: idx_242129_sqlite_autoindex_SERIES_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242129_sqlite_autoindex_SERIES_1" ON public.series USING btree ("ID");


--
-- Name: idx_242147_idx__series_metadata__title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242147_idx__series_metadata__title ON public.series_metadata USING btree ("TITLE");


--
-- Name: idx_242147_sqlite_autoindex_SERIES_METADATA_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242147_sqlite_autoindex_SERIES_METADATA_1" ON public.series_metadata USING btree ("SERIES_ID");


--
-- Name: idx_242191_idx__series_metadata_alternate_title__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242191_idx__series_metadata_alternate_title__series_id ON public.series_metadata_alternate_title USING btree ("SERIES_ID");


--
-- Name: idx_242199_idx__series_metadata_genre__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242199_idx__series_metadata_genre__series_id ON public.series_metadata_genre USING btree ("SERIES_ID");


--
-- Name: idx_242206_idx__series_metadata_link__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242206_idx__series_metadata_link__series_id ON public.series_metadata_link USING btree ("SERIES_ID");


--
-- Name: idx_242214_idx__series_metadata_sharing__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242214_idx__series_metadata_sharing__series_id ON public.series_metadata_sharing USING btree ("SERIES_ID");


--
-- Name: idx_242221_idx__series_metadata_tag__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242221_idx__series_metadata_tag__series_id ON public.series_metadata_tag USING btree ("SERIES_ID");


--
-- Name: idx_242228_sqlite_autoindex_SERVER_SETTINGS_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242228_sqlite_autoindex_SERVER_SETTINGS_1" ON public.server_settings USING btree ("KEY");


--
-- Name: idx_242234_sqlite_autoindex_SIDECAR_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242234_sqlite_autoindex_SIDECAR_1" ON public.sidecar USING btree ("URL");


--
-- Name: idx_242243_idx__sync_point__user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242243_idx__sync_point__user_id ON public.sync_point USING btree ("USER_ID");


--
-- Name: idx_242243_sqlite_autoindex_SYNC_POINT_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242243_sqlite_autoindex_SYNC_POINT_1" ON public.sync_point USING btree ("ID");


--
-- Name: idx_242252_idx__sync_point_book__sync_point_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242252_idx__sync_point_book__sync_point_id ON public.sync_point_book USING btree ("SYNC_POINT_ID");


--
-- Name: idx_242252_sqlite_autoindex_SYNC_POINT_BOOK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242252_sqlite_autoindex_SYNC_POINT_BOOK_1" ON public.sync_point_book USING btree ("SYNC_POINT_ID", "BOOK_ID");


--
-- Name: idx_242267_idx__sync_point_book_removed_status__sync_point_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242267_idx__sync_point_book_removed_status__sync_point_id ON public.sync_point_book_removed_synced USING btree ("SYNC_POINT_ID");


--
-- Name: idx_242267_sqlite_autoindex_SYNC_POINT_BOOK_REMOVED_SYNCED_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242267_sqlite_autoindex_SYNC_POINT_BOOK_REMOVED_SYNCED_1" ON public.sync_point_book_removed_synced USING btree ("SYNC_POINT_ID", "BOOK_ID");


--
-- Name: idx_242274_idx__sync_point_readlist__sync_point_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242274_idx__sync_point_readlist__sync_point_id ON public.sync_point_readlist USING btree ("SYNC_POINT_ID");


--
-- Name: idx_242274_sqlite_autoindex_SYNC_POINT_READLIST_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242274_sqlite_autoindex_SYNC_POINT_READLIST_1" ON public.sync_point_readlist USING btree ("SYNC_POINT_ID", "READLIST_ID");


--
-- Name: idx_242286_idx__sync_point_readlist_book__sync_point_id_readlis; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242286_idx__sync_point_readlist_book__sync_point_id_readlis ON public.sync_point_readlist_book USING btree ("SYNC_POINT_ID", "READLIST_ID");


--
-- Name: idx_242286_sqlite_autoindex_SYNC_POINT_READLIST_BOOK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242286_sqlite_autoindex_SYNC_POINT_READLIST_BOOK_1" ON public.sync_point_readlist_book USING btree ("SYNC_POINT_ID", "READLIST_ID", "BOOK_ID");


--
-- Name: idx_242294_sqlite_autoindex_SYNC_POINT_READLIST_REMOVED_SYNCED_; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242294_sqlite_autoindex_SYNC_POINT_READLIST_REMOVED_SYNCED_" ON public.sync_point_readlist_removed_synced USING btree ("SYNC_POINT_ID", "READLIST_ID");


--
-- Name: idx_242301_idx__thumbnail_book__book_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242301_idx__thumbnail_book__book_id ON public.thumbnail_book USING btree ("BOOK_ID");


--
-- Name: idx_242301_idx__thumbnail_book__file_size; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242301_idx__thumbnail_book__file_size ON public.thumbnail_book USING btree ("FILE_SIZE");


--
-- Name: idx_242301_idx__thumbnail_book__height; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242301_idx__thumbnail_book__height ON public.thumbnail_book USING btree ("HEIGHT");


--
-- Name: idx_242301_idx__thumbnail_book__width; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242301_idx__thumbnail_book__width ON public.thumbnail_book USING btree ("WIDTH");


--
-- Name: idx_242301_sqlite_autoindex_THUMBNAIL_BOOK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242301_sqlite_autoindex_THUMBNAIL_BOOK_1" ON public.thumbnail_book USING btree ("ID");


--
-- Name: idx_242322_idx__thumbnail_collection__collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242322_idx__thumbnail_collection__collection_id ON public.thumbnail_collection USING btree ("COLLECTION_ID");


--
-- Name: idx_242322_sqlite_autoindex_THUMBNAIL_COLLECTION_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242322_sqlite_autoindex_THUMBNAIL_COLLECTION_1" ON public.thumbnail_collection USING btree ("ID");


--
-- Name: idx_242344_idx__thumbnail_readlist__readlist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242344_idx__thumbnail_readlist__readlist_id ON public.thumbnail_readlist USING btree ("READLIST_ID");


--
-- Name: idx_242344_sqlite_autoindex_THUMBNAIL_READLIST_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242344_sqlite_autoindex_THUMBNAIL_READLIST_1" ON public.thumbnail_readlist USING btree ("ID");


--
-- Name: idx_242366_idx__thumbnail_series__series_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242366_idx__thumbnail_series__series_id ON public.thumbnail_series USING btree ("SERIES_ID");


--
-- Name: idx_242366_sqlite_autoindex_THUMBNAIL_SERIES_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242366_sqlite_autoindex_THUMBNAIL_SERIES_1" ON public.thumbnail_series USING btree ("ID");


--
-- Name: idx_242387_sqlite_autoindex_USER_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242387_sqlite_autoindex_USER_1" ON public."user" USING btree ("ID");


--
-- Name: idx_242387_sqlite_autoindex_USER_2; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242387_sqlite_autoindex_USER_2" ON public."user" USING btree ("EMAIL");


--
-- Name: idx_242401_idx__user_api_key__user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242401_idx__user_api_key__user_id ON public.user_api_key USING btree ("USER_ID");


--
-- Name: idx_242401_sqlite_autoindex_USER_API_KEY_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242401_sqlite_autoindex_USER_API_KEY_1" ON public.user_api_key USING btree ("ID");


--
-- Name: idx_242401_sqlite_autoindex_USER_API_KEY_2; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242401_sqlite_autoindex_USER_API_KEY_2" ON public.user_api_key USING btree ("API_KEY");


--
-- Name: idx_242414_sqlite_autoindex_USER_LIBRARY_SHARING_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242414_sqlite_autoindex_USER_LIBRARY_SHARING_1" ON public.user_library_sharing USING btree ("USER_ID", "LIBRARY_ID");


--
-- Name: idx_242421_sqlite_autoindex_USER_ROLE_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242421_sqlite_autoindex_USER_ROLE_1" ON public.user_role USING btree ("USER_ID", "ROLE");


--
-- Name: idx_242428_sqlite_autoindex_USER_SHARING_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242428_sqlite_autoindex_USER_SHARING_1" ON public.user_sharing USING btree ("LABEL", "ALLOW", "USER_ID");


--
-- Name: announcements_read fk_ANNOUNCEMENTS_READ_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements_read
    ADD CONSTRAINT "fk_ANNOUNCEMENTS_READ_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: authentication_activity fk_AUTHENTICATION_ACTIVITY_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_activity
    ADD CONSTRAINT "fk_AUTHENTICATION_ACTIVITY_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: book fk_BOOK_LIBRARY_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT "fk_BOOK_LIBRARY_ID" FOREIGN KEY ("LIBRARY_ID") REFERENCES public.library("ID");


--
-- Name: book_metadata_aggregation_author fk_BOOK_METADATA_AGGREGATION_AUTHOR_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_aggregation_author
    ADD CONSTRAINT "fk_BOOK_METADATA_AGGREGATION_AUTHOR_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: book_metadata_aggregation fk_BOOK_METADATA_AGGREGATION_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_aggregation
    ADD CONSTRAINT "fk_BOOK_METADATA_AGGREGATION_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: book_metadata_aggregation_tag fk_BOOK_METADATA_AGGREGATION_TAG_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_aggregation_tag
    ADD CONSTRAINT "fk_BOOK_METADATA_AGGREGATION_TAG_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: book_metadata_author fk_BOOK_METADATA_AUTHOR_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_author
    ADD CONSTRAINT "fk_BOOK_METADATA_AUTHOR_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: book_metadata fk_BOOK_METADATA_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata
    ADD CONSTRAINT "fk_BOOK_METADATA_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: book_metadata_link fk_BOOK_METADATA_LINK_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_link
    ADD CONSTRAINT "fk_BOOK_METADATA_LINK_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: book_metadata_tag fk_BOOK_METADATA_TAG_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_metadata_tag
    ADD CONSTRAINT "fk_BOOK_METADATA_TAG_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: book fk_BOOK_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT "fk_BOOK_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: client_settings_user fk_CLIENT_SETTINGS_USER_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_settings_user
    ADD CONSTRAINT "fk_CLIENT_SETTINGS_USER_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: collection_series fk_COLLECTION_SERIES_COLLECTION_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_series
    ADD CONSTRAINT "fk_COLLECTION_SERIES_COLLECTION_ID" FOREIGN KEY ("COLLECTION_ID") REFERENCES public.collection("ID");


--
-- Name: collection_series fk_COLLECTION_SERIES_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection_series
    ADD CONSTRAINT "fk_COLLECTION_SERIES_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: historical_event_properties fk_HISTORICAL_EVENT_PROPERTIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_event_properties
    ADD CONSTRAINT "fk_HISTORICAL_EVENT_PROPERTIES_ID" FOREIGN KEY ("ID") REFERENCES public.historical_event("ID");


--
-- Name: library_exclusions fk_LIBRARY_EXCLUSIONS_LIBRARY_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.library_exclusions
    ADD CONSTRAINT "fk_LIBRARY_EXCLUSIONS_LIBRARY_ID" FOREIGN KEY ("LIBRARY_ID") REFERENCES public.library("ID");


--
-- Name: media fk_MEDIA_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT "fk_MEDIA_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: media_file fk_MEDIA_FILE_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_file
    ADD CONSTRAINT "fk_MEDIA_FILE_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: media_page fk_MEDIA_PAGE_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_page
    ADD CONSTRAINT "fk_MEDIA_PAGE_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: readlist_book fk_READLIST_BOOK_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readlist_book
    ADD CONSTRAINT "fk_READLIST_BOOK_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: readlist_book fk_READLIST_BOOK_READLIST_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readlist_book
    ADD CONSTRAINT "fk_READLIST_BOOK_READLIST_ID" FOREIGN KEY ("READLIST_ID") REFERENCES public.readlist("ID");


--
-- Name: read_progress fk_READ_PROGRESS_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress
    ADD CONSTRAINT "fk_READ_PROGRESS_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: read_progress_series fk_READ_PROGRESS_SERIES_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress_series
    ADD CONSTRAINT "fk_READ_PROGRESS_SERIES_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: read_progress_series fk_READ_PROGRESS_SERIES_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress_series
    ADD CONSTRAINT "fk_READ_PROGRESS_SERIES_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: read_progress fk_READ_PROGRESS_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.read_progress
    ADD CONSTRAINT "fk_READ_PROGRESS_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: series fk_SERIES_LIBRARY_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT "fk_SERIES_LIBRARY_ID" FOREIGN KEY ("LIBRARY_ID") REFERENCES public.library("ID");


--
-- Name: series_metadata_alternate_title fk_SERIES_METADATA_ALTERNATE_TITLE_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata_alternate_title
    ADD CONSTRAINT "fk_SERIES_METADATA_ALTERNATE_TITLE_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: series_metadata_genre fk_SERIES_METADATA_GENRE_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata_genre
    ADD CONSTRAINT "fk_SERIES_METADATA_GENRE_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: series_metadata_link fk_SERIES_METADATA_LINK_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata_link
    ADD CONSTRAINT "fk_SERIES_METADATA_LINK_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: series_metadata fk_SERIES_METADATA_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata
    ADD CONSTRAINT "fk_SERIES_METADATA_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: series_metadata_sharing fk_SERIES_METADATA_SHARING_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata_sharing
    ADD CONSTRAINT "fk_SERIES_METADATA_SHARING_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: series_metadata_tag fk_SERIES_METADATA_TAG_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_metadata_tag
    ADD CONSTRAINT "fk_SERIES_METADATA_TAG_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: sync_point_book_removed_synced fk_SYNC_POINT_BOOK_REMOVED_SYNCED_SYNC_POINT_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_book_removed_synced
    ADD CONSTRAINT "fk_SYNC_POINT_BOOK_REMOVED_SYNCED_SYNC_POINT_ID" FOREIGN KEY ("SYNC_POINT_ID") REFERENCES public.sync_point("ID");


--
-- Name: sync_point_book fk_SYNC_POINT_BOOK_SYNC_POINT_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_book
    ADD CONSTRAINT "fk_SYNC_POINT_BOOK_SYNC_POINT_ID" FOREIGN KEY ("SYNC_POINT_ID") REFERENCES public.sync_point("ID");


--
-- Name: sync_point_readlist_book fk_SYNC_POINT_READLIST_BOOK_SYNC_POINT_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist_book
    ADD CONSTRAINT "fk_SYNC_POINT_READLIST_BOOK_SYNC_POINT_ID" FOREIGN KEY ("SYNC_POINT_ID") REFERENCES public.sync_point("ID");


--
-- Name: sync_point_readlist_removed_synced fk_SYNC_POINT_READLIST_REMOVED_SYNCED_SYNC_POINT_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist_removed_synced
    ADD CONSTRAINT "fk_SYNC_POINT_READLIST_REMOVED_SYNCED_SYNC_POINT_ID" FOREIGN KEY ("SYNC_POINT_ID") REFERENCES public.sync_point("ID");


--
-- Name: sync_point_readlist fk_SYNC_POINT_READLIST_SYNC_POINT_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point_readlist
    ADD CONSTRAINT "fk_SYNC_POINT_READLIST_SYNC_POINT_ID" FOREIGN KEY ("SYNC_POINT_ID") REFERENCES public.sync_point("ID");


--
-- Name: sync_point fk_SYNC_POINT_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_point
    ADD CONSTRAINT "fk_SYNC_POINT_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: thumbnail_book fk_THUMBNAIL_BOOK_BOOK_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_book
    ADD CONSTRAINT "fk_THUMBNAIL_BOOK_BOOK_ID" FOREIGN KEY ("BOOK_ID") REFERENCES public.book("ID");


--
-- Name: thumbnail_collection fk_THUMBNAIL_COLLECTION_COLLECTION_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_collection
    ADD CONSTRAINT "fk_THUMBNAIL_COLLECTION_COLLECTION_ID" FOREIGN KEY ("COLLECTION_ID") REFERENCES public.collection("ID");


--
-- Name: thumbnail_readlist fk_THUMBNAIL_READLIST_READLIST_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_readlist
    ADD CONSTRAINT "fk_THUMBNAIL_READLIST_READLIST_ID" FOREIGN KEY ("READLIST_ID") REFERENCES public.readlist("ID");


--
-- Name: thumbnail_series fk_THUMBNAIL_SERIES_SERIES_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thumbnail_series
    ADD CONSTRAINT "fk_THUMBNAIL_SERIES_SERIES_ID" FOREIGN KEY ("SERIES_ID") REFERENCES public.series("ID");


--
-- Name: user_api_key fk_USER_API_KEY_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_api_key
    ADD CONSTRAINT "fk_USER_API_KEY_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: user_library_sharing fk_USER_LIBRARY_SHARING_LIBRARY_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_library_sharing
    ADD CONSTRAINT "fk_USER_LIBRARY_SHARING_LIBRARY_ID" FOREIGN KEY ("LIBRARY_ID") REFERENCES public.library("ID");


--
-- Name: user_library_sharing fk_USER_LIBRARY_SHARING_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_library_sharing
    ADD CONSTRAINT "fk_USER_LIBRARY_SHARING_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: user_role fk_USER_ROLE_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT "fk_USER_ROLE_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: user_sharing fk_USER_SHARING_USER_ID; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sharing
    ADD CONSTRAINT "fk_USER_SHARING_USER_ID" FOREIGN KEY ("USER_ID") REFERENCES public."user"("ID");


--
-- Name: task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task (
                            "ID" text NOT NULL,
                            "PRIORITY" integer NOT NULL,
                            "GROUP_ID" text,
                            "CLASS" text NOT NULL,
                            "SIMPLE_TYPE" text NOT NULL,
                            "PAYLOAD" text NOT NULL,
                            "OWNER" text,
                            "CREATED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
                            "LAST_MODIFIED_DATE" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: task idx_242830_PRIMARY; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT "idx_242830_PRIMARY" PRIMARY KEY ("ID");


--
-- Name: idx_242830_idx__public__owner_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_242830_idx__public__owner_group_id ON public.task USING btree ("OWNER", "GROUP_ID");


--
-- Name: idx_242830_sqlite_autoindex_TASK_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_242830_sqlite_autoindex_TASK_1" ON public.task USING btree ("ID");
