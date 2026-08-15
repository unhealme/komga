CREATE TABLE public.book_projection
(
    "BOOK_ID"            char(13)   NOT NULL,
    "PROFILE"            varchar    NOT NULL,
    "FILE_SIZE"          int8       NOT NULL,
    "CREATED_DATE"       timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "LAST_MODIFIED_DATE" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("BOOK_ID", "PROFILE"),
    FOREIGN KEY ("BOOK_ID") REFERENCES public."book" ("ID")
);
