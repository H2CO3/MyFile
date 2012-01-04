//
// MFPictureMetadata.m
// MyFile
//
// Created by Árpád Goretity, 2011.
//

#import "MFPictureMetadata.h"

#define _(x) x
#define N_(x) x
#define exif_entry_log(x...) do { } while (0)
#define CF(entry,target,v,maxlen)					\
{									\
	if (entry->format != target) {					\
		exif_entry_log (entry, EXIF_LOG_CODE_CORRUPT_DATA,	\
			_("The tag '%s' contains data of an invalid "	\
			"format ('%s', expected '%s')."),		\
			exif_tag_get_name (entry->tag), 		\
			exif_format_get_name (entry->format),		\
			exif_format_get_name (target)); 		\
		break;							\
	}								\
}
#define CC(entry,target,v,maxlen)					\
{									\
	if (entry->components != target) {				\
		exif_entry_log (entry, EXIF_LOG_CODE_CORRUPT_DATA,	\
			_("The tag '%s' contains an invalid number of " \
			  "components (%i, expected %i)."),		\
			exif_tag_get_name (entry->tag), 	\
			(int) entry->components, (int) target); 	\
		break;							\
	}								\
}

static const struct {
	ExifTag tag;
	const char *strings[10];
} list[] = {
#ifndef NO_VERBOSE_TAG_DATA
  { EXIF_TAG_PLANAR_CONFIGURATION,
    { N_("0"), N_("1"), NULL}},
  { EXIF_TAG_SENSING_METHOD,
    { "0", N_("1"), N_("2"),
      N_("3"), N_("4"),
      N_("5"), "6", N_("7"),
      N_("8"), NULL}},
  { EXIF_TAG_ORIENTATION,
    { "0", N_("1"), N_("2"), N_("3"),
      N_("4"), N_("5"), N_("6"),
      N_("7"), N_("8"), NULL}},
  { EXIF_TAG_YCBCR_POSITIONING,
    { "0", N_("1"), N_("1"), NULL}},
  { EXIF_TAG_PHOTOMETRIC_INTERPRETATION,
    { N_("0"), N_("1"), N_("2"), N_("3"), "4",
      N_("5"), N_("6"), "", N_("7"), NULL}},
  { EXIF_TAG_CUSTOM_RENDERED,
    { N_("0"), N_("1"), NULL}},
  { EXIF_TAG_EXPOSURE_MODE,
    { N_("0"), N_("1"), N_("2"), NULL}},
  { EXIF_TAG_WHITE_BALANCE,
    { N_("0"), N_("1"), NULL}},
  { EXIF_TAG_SCENE_CAPTURE_TYPE,
    { N_("0"), N_("1"), N_("2"),
      N_("3"), NULL}},
  { EXIF_TAG_GAIN_CONTROL,
    { N_("0"), N_("1"), N_("2"),
      N_("3"), N_("4"), NULL}},
  { EXIF_TAG_SATURATION,
    { N_("0"), N_("1"), N_("2"), NULL}},
  { EXIF_TAG_CONTRAST , {N_("0"), N_("1"), N_("2"), NULL}},
  { EXIF_TAG_SHARPNESS, {N_("0"), N_("1"), N_("2"), NULL}},
#endif
  { 0, {NULL}}
};

static const struct {
  ExifTag tag;
  struct {
    int index;
    const char *values[4]; /*!< list of progressively shorter string
			    descriptions; the longest one that fits will be
			    selected */
  } elem[25];
} list2[] = {
#ifndef NO_VERBOSE_TAG_DATA
  { EXIF_TAG_METERING_MODE,
    { {  0, {N_("0"), NULL}},
      {  1, {N_("1"), N_("1"), NULL}},
      {  2, {N_("2"), N_("2"), NULL}},
      {  3, {N_("3"), NULL}},
      {  4, {N_("4"), NULL}},
      {  5, {N_("5"), NULL}},
      {  6, {N_("6"), NULL}},
      {255, {N_("255"), NULL}},
      {  0, {NULL}}}},
  { EXIF_TAG_COMPRESSION,
    { {1, {N_("1"), NULL}},
      {5, {N_("5"), NULL}},
      {6, {N_("6"), NULL}},
      {7, {N_("7"), NULL}},
      {8, {N_("8"), NULL}},
      {32773, {N_("32773"), NULL}},
      {0, {NULL}}}},
  { EXIF_TAG_LIGHT_SOURCE,
    { {  0, {N_("0"), NULL}},
      {  1, {N_("1"), NULL}},
      {  2, {N_("2"), NULL}},
      {  3, {N_("3"), N_("3"), NULL}},
      {  4, {N_("4"), NULL}},
      {  9, {N_("9"), NULL}},
      { 10, {N_("10"), N_("10"), NULL}},
      { 11, {N_("11"), NULL}},
      { 12, {N_("12t"), NULL}},
      { 13, {N_("13"), NULL}},
      { 14, {N_("14"), NULL}},
      { 15, {N_("15"), NULL}},
      { 17, {N_("17"), NULL}},
      { 18, {N_("18"), NULL}},
      { 19, {N_("19"), NULL}},
      { 20, {N_("20"), NULL}},
      { 21, {N_("21"), NULL}},
      { 22, {N_("22"), NULL}},
      { 24, {N_("24"),NULL}},
      {255, {N_("255"), NULL}},
      {  0, {NULL}}}},
  { EXIF_TAG_FOCAL_PLANE_RESOLUTION_UNIT,
    { {2, {N_("2"), N_("2"), NULL}},
      {3, {N_("3"), N_("3"), NULL}},
      {0, {NULL}}}},
  { EXIF_TAG_RESOLUTION_UNIT,
    { {2, {N_("2"), N_("2"), NULL}},
      {3, {N_("3"), N_("3"), NULL}}, 
      {0, {NULL}}}},
  { EXIF_TAG_EXPOSURE_PROGRAM,
    { {0, {N_("0"), NULL}},
      {1, {N_("1"), NULL}},
      {2, {N_("2"), N_("2"), NULL}},
      {3, {N_("3"), N_("3"), NULL}},
      {4, {N_("4"),N_("4"), NULL}},
      {5, {N_("5"),
	   N_("5"), NULL}},
      {6, {N_("6"),
	   N_("6"), NULL}},
      {7, {N_("7"), N_("7"), NULL}},
      {8, {N_("8"), N_("8"), NULL}},
      {0, {NULL}}}},
  { EXIF_TAG_FLASH,
    { {0x0000, {N_("0"), N_("0"), NULL}},
      {0x0001, {N_("1"), N_("1"), N_("1"), NULL}},
      {0x0005, {N_("5"), N_("5"),
		NULL}},
      {0x0007, {N_("7"), N_("7"), NULL}},
      {0x0008, {N_("8"), NULL}}, /* Olympus E-330 */
      {0x0009, {N_("9"), NULL}},
      {0x000d, {N_("13"), NULL}},
      {0x000f, {N_("15"), NULL}},
      {0x0010, {N_("16"), NULL}},
      {0x0018, {N_("24"), NULL}},
      {0x0019, {N_("25"), NULL}},
      {0x001d, {N_("29"),
		NULL}},
      {0x001f, {N_("3"), NULL}},
      {0x0020, {N_("32"),NULL}},
      {0x0041, {N_("65"), NULL}},
      {0x0045, {N_("69"), NULL}},
      {0x0047, {N_("71"), NULL}},
      {0x0049, {N_("73"), NULL}},
      {0x004d, {N_("77"), NULL}},
      {0x004f, {N_("79"), NULL}},
      {0x0058, {N_("88"), NULL}},
      {0x0059, {N_("89"), NULL}},
      {0x005d, {N_("93"), NULL}},
      {0x005f, {N_("95"), NULL}},
      {0x0000, {NULL}}}},
  { EXIF_TAG_SUBJECT_DISTANCE_RANGE, 
    { {0, {N_("0"), N_("0"), NULL}},
      {1, {N_("1"), NULL}},
      {2, {N_("2"), N_("2"), NULL}},
      {3, {N_("3"), N_("3"), NULL}},
      {0, {NULL}}}},
  { EXIF_TAG_COLOR_SPACE,
    { {1, {N_("1"), NULL}},
      {2, {N_("2"), NULL}},
      {0xffff, {N_("65535"), NULL}},
      {0x0000, {NULL}}}},
#endif
  {0, { { 0, {NULL}}} }
};

void exif_convert_utf16_to_utf8 (char *out, const unsigned short *in, int maxlen) {

	if (maxlen <= 0) {
		return;
	}
	while (*in) {
		if (*in < 0x80) {
			if (maxlen > 1) {
				*out++ = (char)*in++;
				maxlen--;
			} else {
				break;
			}
		} else if (*in < 0x800) {
			if (maxlen > 2) {
				*out++ = ((*in >> 6) & 0x1F) | 0xC0;
				*out++ = (*in++ & 0x3F) | 0x80;
				maxlen -= 2;
			} else {
				break;
			}
		} else {
			if (maxlen > 2) {
				*out++ = ((*in >> 12) & 0x0F) | 0xE0;
				*out++ = ((*in >> 6) & 0x3F) | 0x80;
				*out++ = (*in++ & 0x3F) | 0x80;
				maxlen -= 3;
			} else {
				break;
			}
		}
	}
	*out = 0;
}

void exif_entry_format_value (ExifEntry *e, char *val, size_t maxlen) {

	ExifByte v_byte;
	ExifShort v_short;
	ExifSShort v_sshort;
	ExifLong v_long;
	ExifRational v_rat;
	ExifSRational v_srat;
	ExifSLong v_slong;
	char b[64];
	unsigned int i;
	const ExifByteOrder o = exif_data_get_byte_order (e->parent->parent);

	if (!e->size)
		return;
	switch (e->format) {
	case EXIF_FORMAT_UNDEFINED:
		snprintf (val, maxlen, _("%i bytes undefined data"), e->size);
		break;
	case EXIF_FORMAT_BYTE:
	case EXIF_FORMAT_SBYTE:
		v_byte = e->data[0];
		snprintf (val, maxlen, "0x%02x", v_byte);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_byte = e->data[i];
			snprintf (b, sizeof (b), ", 0x%02x", v_byte);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_SHORT:
		v_short = exif_get_short (e->data, o);
		snprintf (val, maxlen, "%u", v_short);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_short = exif_get_short (e->data +
				exif_format_get_size (e->format) * i, o);
			snprintf (b, sizeof (b), ", %u", v_short);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_SSHORT:
		v_sshort = exif_get_sshort (e->data, o);
		snprintf (val, maxlen, "%i", v_sshort);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_sshort = exif_get_short (e->data +
				exif_format_get_size (e->format) *
				i, o);
			snprintf (b, sizeof (b), ", %i", v_sshort);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_LONG:
		v_long = exif_get_long (e->data, o);
		snprintf (val, maxlen, "%lu", (unsigned long) v_long);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_long = exif_get_long (e->data +
				exif_format_get_size (e->format) *
				i, o);
			snprintf (b, sizeof (b), ", %lu", (unsigned long) v_long);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_SLONG:
		v_slong = exif_get_slong (e->data, o);
		snprintf (val, maxlen, "%li", (long) v_slong);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_slong = exif_get_slong (e->data +
				exif_format_get_size (e->format) * i, o);
			snprintf (b, sizeof (b), ", %li", (long) v_slong);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_ASCII:
		strncpy (val, (char *) e->data, MIN (maxlen, e->size));
		break;
	case EXIF_FORMAT_RATIONAL:
		for (i = 0; i < e->components; i++) {
			if (i > 0) {
				strncat (val, ", ", maxlen);
				maxlen -= 2;
			}
			v_rat = exif_get_rational (
				e->data + 8 * i, o);
			if (v_rat.denominator) {
				/*
				 * Choose the number of significant digits to
				 * display based on the size of the denominator.
				 * It is scaled so that denominators within the
				 * range 13..120 will show 2 decimal points.
				 */
				int decimals = (int)(log10(v_rat.denominator)-0.08+1.0);
				snprintf (b, sizeof (b), "%2.*f",
					  decimals,
					  (double) v_rat.numerator /
					  (double) v_rat.denominator);
			} else
				snprintf (b, sizeof (b), "%lu/%lu",
				  (unsigned long) v_rat.numerator,
				  (unsigned long) v_rat.denominator);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed) maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_SRATIONAL:
		for (i = 0; i < e->components; i++) {
			if (i > 0) {
				strncat (val, ", ", maxlen);
				maxlen -= 2;
			}
			v_srat = exif_get_srational (
				e->data + 8 * i, o);
			if (v_srat.denominator) {
				int decimals = (int)(log10(fabs(v_srat.denominator))-0.08+1.0);
				snprintf (b, sizeof (b), "%2.*f",
					  decimals,
					  (double) v_srat.numerator /
					  (double) v_srat.denominator);
			} else
				snprintf (b, sizeof (b), "%li/%li",
				  (long) v_srat.numerator,
				  (long) v_srat.denominator);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed) maxlen <= 0) break;
		}
		break;
	case EXIF_FORMAT_DOUBLE:
	case EXIF_FORMAT_FLOAT:
	default:
		snprintf (val, maxlen, _("%i bytes unsupported data type"),
			  e->size);
		break;
	}
}

@implementation MFPictureMetadata

// self

- (id) initWithFileName: (NSString *) fileName {

	self = [super init];
	
	file = [fileName copy];

	exif_loader = exif_loader_new ();
	exif_loader_write_file (exif_loader, [file UTF8String]);
	exif_data = exif_loader_get_data (exif_loader);
	exif_data_set_byte_order (exif_data, EXIF_BYTE_ORDER_INTEL);
	
	return self;
	
}

- (NSString *) valueForTag: (ExifTag) tag {

	char *buf = malloc (sizeof (char) * 1024);
	ExifEntry *exif_entry = exif_data_get_entry (exif_data, tag);
	exif_entry_get_value (exif_entry, buf, 1024);
	NSString *str = [[NSString alloc] initWithUTF8String: buf];
	free (buf);
	
	return [str autorelease];

}

- (NSString *) rawValueForTag: (ExifTag) tag {

	ExifEntry *e = exif_data_get_entry (exif_data, tag);
	unsigned maxlen = 1024;
	char *val = malloc (sizeof (char) * maxlen);
	unsigned int i, j, k;
	const unsigned char *t;
	ExifShort v_short, v_short1, v_short2, v_short3, v_short4;
	ExifByte v_byte;
	ExifRational v_rat;
	ExifSRational v_srat;
	char b[64];
	const char *c;
	ExifByteOrder o;
	double d;
	ExifEntry *entry;
	static const struct {
		char label[5];
		char major, minor;
	} versions[] = {
		{"0110", 1,  1},
		{"0120", 1,  2},
		{"0200", 2,  0},
		{"0210", 2,  1},
		{"0220", 2,  2},
		{"0221", 2, 21},
		{""    , 0,  0}
	};

	/* FIXME: This belongs to somewhere else. */
	/* libexif should use the default system locale.
	 * If an application specifically requires UTF-8, then we
	 * must give the application a way to tell libexif that.
	 * 
	 * bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
	 */
	// bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);

	/* make sure the returned string is zero terminated */
	memset (val, 0, maxlen);
	maxlen--;
	memset (b, 0, sizeof (b));

	/* We need the byte order */
	if (!e || !e->parent || !e->parent->parent)
		return [NSString stringWithUTF8String: val];
	o = exif_data_get_byte_order (e->parent->parent);

	/* Sanity check */
	if (e->size != e->components * exif_format_get_size (e->format)) {
		snprintf (val, maxlen, _("Invalid size of entry (%i, "
			"expected %li x %i)."), e->size, e->components,
				exif_format_get_size (e->format));
		return [NSString stringWithUTF8String: val];
	}

	switch (e->tag) {
	case EXIF_TAG_USER_COMMENT:

		/*
		 * The specification says UNDEFINED, but some
		 * manufacturers don't care and use ASCII. If this is the
		 * case here, only refuse to read it if there is no chance
		 * of finding readable data.
		 */
		if ((e->format != EXIF_FORMAT_ASCII) || 
		    (e->size <= 8) ||
		    ( memcmp (e->data, "ASCII\0\0\0"  , 8) &&
		      memcmp (e->data, "UNICODE\0"    , 8) &&
		      memcmp (e->data, "JIS\0\0\0\0\0", 8) &&
		      memcmp (e->data, "\0\0\0\0\0\0\0\0", 8)))
			CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);

		/*
		 * Note that, according to the specification (V2.1, p 40),
		 * the user comment field does not have to be 
		 * NULL terminated.
		 */
		if ((e->size >= 8) && !memcmp (e->data, "ASCII\0\0\0", 8)) {
			strncpy (val, (char *) e->data + 8, MIN (e->size - 8, maxlen));
			break;
		}
		if ((e->size >= 8) && !memcmp (e->data, "UNICODE\0", 8)) {
			strncpy (val, _("Unsupported UNICODE string"), maxlen);
		/* FIXME: use iconv to convert into the locale encoding.
		 * EXIF 2.2 implies (but does not say) that this encoding is
		 * UCS-2.
		 */
			break;
		}
		if ((e->size >= 8) && !memcmp (e->data, "JIS\0\0\0\0\0", 8)) {
			strncpy (val, _("Unsupported JIS string"), maxlen);
		/* FIXME: use iconv to convert into the locale encoding */
			break;
		}

		/* Check if there is really some information in the tag. */
		for (i = 0; (i < e->size) &&
			    (!e->data[i] || (e->data[i] == ' ')); i++);
		if (i == e->size) break;

		/*
		 * If we reach this point, the tag does not
		 * comply with the standard and seems to contain data.
		 * Print as much as possible.
		 */
		exif_entry_log (e, EXIF_LOG_CODE_DEBUG,
			_("Tag UserComment does not comply "
			"with standard but contains data."));
		for (; (i < e->size)  && (strlen (val) < maxlen - 1); i++) {
			exif_entry_log (e, EXIF_LOG_CODE_DEBUG,
				_("Byte at position %i: 0x%02x"), i, e->data[i]);
			val[strlen (val)] =
				isprint (e->data[i]) ? e->data[i] : '.';
		}
		break;

	case EXIF_TAG_EXIF_VERSION:
		CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);
		CC (e, 4, val, maxlen);
		strncpy (val, _("Unknown Exif Version"), maxlen);
		for (i = 0; *versions[i].label; i++) {
			if (!memcmp (e->data, versions[i].label, 4)) {
				snprintf (val, maxlen,
					_("Exif Version %d.%d"),
					versions[i].major,
					versions[i].minor);
				break;
			}
		}
		break;
	case EXIF_TAG_FLASH_PIX_VERSION:
		CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);
		CC (e, 4, val, maxlen);
		if (!memcmp (e->data, "0100", 4))
			strncpy (val, _("0100"), maxlen);
		else if (!memcmp (e->data, "0101", 4))
			strncpy (val, _("0101"), maxlen);
		else
			strncpy (val, _("0000"), maxlen);
		break;
	case EXIF_TAG_COPYRIGHT:
		CF (e, EXIF_FORMAT_ASCII, val, maxlen);

		/*
		 * First part: Photographer.
		 * Some cameras store a string like "	" here. Ignore it.
		 */
		if (e->size && e->data &&
		    (strspn ((char *)e->data, " ") != strlen ((char *) e->data)))
			strncpy (val, (char *) e->data, MIN (maxlen, e->size));
		else
			strncpy (val, _("[None]"), maxlen);
		strncat (val, " ", maxlen - strlen (val));
		strncat (val, _("(Photographer)"), maxlen - strlen (val));

		/* Second part: Editor. */
		strncat (val, " - ", maxlen - strlen (val));
		if (e->size && e->data) {
			size_t ts;
			t = e->data + strlen ((char *) e->data) + 1;
			ts = e->data + e->size - t;
			if ((ts > 0) && (strspn ((char *)t, " ") != ts))
				strncat (val, (char *)t, MIN (maxlen - strlen (val), ts));
		} else {
			strncat (val, _("[None]"), maxlen - strlen (val));
		}
		strncat (val, " ", maxlen - strlen (val));
		strncat (val, _("(Editor)"), maxlen - strlen (val));

		break;
	case EXIF_TAG_FNUMBER:
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_rat = exif_get_rational (e->data, o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_rat.numerator / (double) v_rat.denominator;
		snprintf (val, maxlen, "f/%.01f", d);
		break;
	case EXIF_TAG_APERTURE_VALUE:
	case EXIF_TAG_MAX_APERTURE_VALUE:
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_rat = exif_get_rational (e->data, o);
		if (!v_rat.denominator || (0x80000000 == v_rat.numerator)) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_rat.numerator / (double) v_rat.denominator;
		snprintf (val, maxlen, _("%.02f"), d);
		if (maxlen > strlen (val) + strlen (b))
			strncat (val, b, maxlen - strlen (val));
		break;
	case EXIF_TAG_FOCAL_LENGTH:
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_rat = exif_get_rational (e->data, o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}

		/*
		 * For calculation of the 35mm equivalent,
		 * Minolta cameras need a multiplier that depends on the
		 * camera model.
		 */
		d = 0.0;
		entry = exif_content_get_entry (
			e->parent->parent->ifd[EXIF_IFD_0], EXIF_TAG_MAKE);
		if (entry && entry->data &&
		    !strncmp ((char *)entry->data, "Minolta", 7)) {
			entry = exif_content_get_entry (
					e->parent->parent->ifd[EXIF_IFD_0],
					EXIF_TAG_MODEL);
			if (entry && entry->data) {
				if (!strncmp ((char *)entry->data, "DiMAGE 7", 8))
					d = 3.9;
				else if (!strncmp ((char *)entry->data, "DiMAGE 5", 8))
					d = 4.9;
			}
		}
		if (d)
			snprintf (b, sizeof (b), _(" (35 equivalent: %d mm)"),
				  (int) (d * (double) v_rat.numerator /
					     (double) v_rat.denominator));

		d = (double) v_rat.numerator / (double) v_rat.denominator;
		snprintf (val, maxlen, "%.1f", d);
		if (maxlen > strlen (val) + strlen (b))
			strncat (val, b, maxlen - strlen (val));
		break;
	case EXIF_TAG_SUBJECT_DISTANCE:
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_rat = exif_get_rational (e->data, o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_rat.numerator / (double) v_rat.denominator;
		snprintf (val, maxlen, "%.1f", d);
		break;
	case EXIF_TAG_EXPOSURE_TIME:
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_rat = exif_get_rational (e->data, o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_rat.numerator / (double) v_rat.denominator;

		snprintf (val, maxlen, _("%f"), d);
		break;
	case EXIF_TAG_SHUTTER_SPEED_VALUE:
		CF (e, EXIF_FORMAT_SRATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_srat = exif_get_srational (e->data, o);
		if (!v_srat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_srat.numerator / (double) v_srat.denominator;
		snprintf (val, maxlen, _("%.02f"), d);
		break;
	case EXIF_TAG_BRIGHTNESS_VALUE:
		CF (e, EXIF_FORMAT_SRATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_srat = exif_get_srational (e->data, o);
		if (!v_srat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_srat.numerator / (double) v_srat.denominator;
		snprintf (val, maxlen, _("%.02f"), d);
		break;
	case EXIF_TAG_FILE_SOURCE:
		CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);
		CC (e, 1, val, maxlen);
		v_byte = e->data[0];
		if (v_byte == 3)
			strncpy (val, _("3"), maxlen);
		else
			snprintf (val, maxlen, _("Internal error (unknown "
				  "value %i)"), v_byte);
		break;
	case EXIF_TAG_COMPONENTS_CONFIGURATION:
		CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);
		CC (e, 4, val, maxlen);
		for (i = 0; i < 4; i++) {
			switch (e->data[i]) {
			case 0: c = _("0"); break;
			case 1: c = _("1"); break;
			case 2: c = _("2"); break;
			case 3: c = _("3"); break;
			case 4: c = _("4"); break;
			case 5: c = _("5"); break;
			case 6: c = _("6"); break;
			default: c = _("7"); break;
			}
			strncat (val, c, maxlen - strlen (val));
			if (i < 3)
				strncat (val, " ", maxlen - strlen (val));
		}
		break;
	case EXIF_TAG_EXPOSURE_BIAS_VALUE:
		CF (e, EXIF_FORMAT_SRATIONAL, val, maxlen);
		CC (e, 1, val, maxlen);
		v_srat = exif_get_srational (e->data, o);
		if (!v_srat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_srat.numerator / (double) v_srat.denominator;
		snprintf (val, maxlen, _("%.02f"), d);
		break;
	case EXIF_TAG_SCENE_TYPE:
		CF (e, EXIF_FORMAT_UNDEFINED, val, maxlen);
		CC (e, 1, val, maxlen);
		v_byte = e->data[0];
		if (v_byte == 1)
			strncpy (val, _("1"), maxlen);
		else
			snprintf (val, maxlen, _("Internal error (unknown "
				  "value %i)"), v_byte);
		break;
	case EXIF_TAG_YCBCR_SUB_SAMPLING:
		CF (e, EXIF_FORMAT_SHORT, val, maxlen);
		CC (e, 2, val, maxlen);
		v_short  = exif_get_short (e->data, o);
		v_short2 = exif_get_short (
			e->data + exif_format_get_size (e->format),
			o);
		if ((v_short == 2) && (v_short2 == 1))
			strncpy (val, _("2, 1"), maxlen);
		else if ((v_short == 2) && (v_short2 == 2))
			strncpy (val, _("2, 2"), maxlen);
		else
			snprintf (val, maxlen, "%u, %u", v_short, v_short2);
		break;
	case EXIF_TAG_SUBJECT_AREA:
		CF (e, EXIF_FORMAT_SHORT, val, maxlen);
		switch (e->components) {
		case 2:
			v_short  = exif_get_short (e->data, o);
			v_short2 = exif_get_short (e->data + 2, o);
			snprintf (val, maxlen, "(x, y) = (%i, %i)",
				  v_short, v_short2);
			break;
		case 3:
			v_short  = exif_get_short (e->data, o);
			v_short2 = exif_get_short (e->data + 2, o);
			v_short3 = exif_get_short (e->data + 4, o);
			snprintf (val, maxlen, _("%i, %i, %i"), v_short, v_short2, v_short3);
			break;
		case 4:
			v_short  = exif_get_short (e->data, o);
			v_short2 = exif_get_short (e->data + 2, o);
			v_short3 = exif_get_short (e->data + 4, o);
			v_short4 = exif_get_short (e->data + 6, o);
			snprintf (val, maxlen, _("%i, %i, %i, %i"), v_short3, v_short1, v_short2, v_short3);
			break;
		default:
			snprintf (val, maxlen, _("Unexpected number "
				"of components (%li, expected 2, 3, or 4)."),
				e->components); 
		}
		break;
	case EXIF_TAG_GPS_VERSION_ID:
		/* This is only valid in the GPS IFD */
		CF (e, EXIF_FORMAT_BYTE, val, maxlen);
		CC (e, 4, val, maxlen);
		v_byte = e->data[0];
		snprintf (val, maxlen, "%u", v_byte);
		maxlen -= strlen (val);
		for (i = 1; i < e->components; i++) {
			v_byte = e->data[i];
			snprintf (b, sizeof (b), "%u", v_byte);
			strncat (val, b, maxlen);
			maxlen -= strlen (b);
			if ((signed)maxlen <= 0) break;
		}
		break;
	case EXIF_TAG_INTEROPERABILITY_VERSION:
	/* a.k.a. case EXIF_TAG_GPS_LATITUDE: */
		/* This tag occurs in EXIF_IFD_INTEROPERABILITY */
		if (e->format == EXIF_FORMAT_UNDEFINED) {
			strncpy (val, (char *) e->data, MIN (maxlen, e->size));
			break;
		}
		/* EXIF_TAG_GPS_LATITUDE is the same numerically as
		 * EXIF_TAG_INTEROPERABILITY_VERSION but in EXIF_IFD_GPS
		 */
		exif_entry_format_value(e, val, maxlen);
		break;
	case EXIF_TAG_GPS_ALTITUDE_REF:
		/* This is only valid in the GPS IFD */
		CF (e, EXIF_FORMAT_BYTE, val, maxlen);
		CC (e, 1, val, maxlen);
		v_byte = e->data[0];
		if (v_byte == 0)
			strncpy (val, _("0"), maxlen);
		else if (v_byte == 1)
			strncpy (val, _("1"), maxlen);
		else
			snprintf (val, maxlen, _("Internal error (unknown value %i)"), v_byte);
		break;
	case EXIF_TAG_GPS_TIME_STAMP:
		/* This is only valid in the GPS IFD */
		CF (e, EXIF_FORMAT_RATIONAL, val, maxlen);
		CC (e, 3, val, maxlen);

		v_rat  = exif_get_rational (e->data, o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		i = v_rat.numerator / v_rat.denominator;

		v_rat = exif_get_rational (e->data +
					     exif_format_get_size (e->format),
					   o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		j = v_rat.numerator / v_rat.denominator;

		v_rat = exif_get_rational (e->data +
					     2 * exif_format_get_size (e->format),
					     o);
		if (!v_rat.denominator) {
			exif_entry_format_value(e, val, maxlen);
			break;
		}
		d = (double) v_rat.numerator / (double) v_rat.denominator;
		snprintf (val, maxlen, "%02u%02u%05.2f", i, j, d);
		break;

	case EXIF_TAG_METERING_MODE:
	case EXIF_TAG_COMPRESSION:
	case EXIF_TAG_LIGHT_SOURCE:
	case EXIF_TAG_FOCAL_PLANE_RESOLUTION_UNIT:
	case EXIF_TAG_RESOLUTION_UNIT:
	case EXIF_TAG_EXPOSURE_PROGRAM:
	case EXIF_TAG_FLASH:
	case EXIF_TAG_SUBJECT_DISTANCE_RANGE:
	case EXIF_TAG_COLOR_SPACE:
		CF (e,EXIF_FORMAT_SHORT, val, maxlen);
		CC (e, 1, val, maxlen);
		v_short = exif_get_short (e->data, o);

		/* Search the tag */
		for (i = 0; list2[i].tag && (list2[i].tag != e->tag); i++);
		if (!list2[i].tag) {
			snprintf (val, maxlen, _("Internal error (unknown "
				  "value %i)"), v_short);
			break;
		}

		/* Find the value */
		for (j = 0; list2[i].elem[j].values[0] &&
			    (list2[i].elem[j].index < v_short); j++);
		if (list2[i].elem[j].index != v_short) {
			snprintf (val, maxlen, _("Internal error (unknown "
				  "value %i)"), v_short);
			break;
		}

		/* Find a short enough value */
		memset (val, 0, maxlen);
		for (k = 0; list2[i].elem[j].values[k]; k++) {
			size_t l = strlen (_(list2[i].elem[j].values[k]));
			if ((maxlen > l) && (strlen (val) < l))
				strncpy (val, _(list2[i].elem[j].values[k]), maxlen);
		}
		if (!val[0]) snprintf (val, maxlen, "%i", v_short);

		break;

	case EXIF_TAG_PLANAR_CONFIGURATION:
	case EXIF_TAG_SENSING_METHOD:
	case EXIF_TAG_ORIENTATION:
	case EXIF_TAG_YCBCR_POSITIONING:
	case EXIF_TAG_PHOTOMETRIC_INTERPRETATION:
	case EXIF_TAG_CUSTOM_RENDERED:
	case EXIF_TAG_EXPOSURE_MODE:
	case EXIF_TAG_WHITE_BALANCE:
	case EXIF_TAG_SCENE_CAPTURE_TYPE:
	case EXIF_TAG_GAIN_CONTROL:
	case EXIF_TAG_SATURATION:
	case EXIF_TAG_CONTRAST:
	case EXIF_TAG_SHARPNESS:
		CF (e, EXIF_FORMAT_SHORT, val, maxlen);
		CC (e, 1, val, maxlen);
		v_short = exif_get_short (e->data, o);

		/* Search the tag */
		for (i = 0; list[i].tag && (list[i].tag != e->tag); i++);
		if (!list[i].tag) {
			snprintf (val, maxlen, _("Internal error (unknown "
				  "value %i)"), v_short);
			break;
		}

		/* Find the value */
		for (j = 0; list[i].strings[j] && (j < v_short); j++);
		if (!list[i].strings[j])
			snprintf (val, maxlen, "%i", v_short);
		else if (!*list[i].strings[j])
			snprintf (val, maxlen, _("Unknown value %i"), v_short);
		else
			strncpy (val, _(list[i].strings[j]), maxlen);
		break;

	case EXIF_TAG_XP_TITLE:
	case EXIF_TAG_XP_COMMENT:
	case EXIF_TAG_XP_AUTHOR:
	case EXIF_TAG_XP_KEYWORDS:
	case EXIF_TAG_XP_SUBJECT:
		/* Warning! The texts are converted from UTF16 to UTF8 */
		/* FIXME: use iconv to convert into the locale encoding */
		exif_convert_utf16_to_utf8(val, (unsigned short*)e->data, MIN(maxlen, e->size));
		break;

	default:
		/* Use a generic value formatting */
		exif_entry_format_value(e, val, maxlen);
	}

	NSString *str = [NSString stringWithUTF8String: val];
	free (val);

	return str;

}

- (void) setValue: (NSString *) value forTag: (ExifTag) tag {

	size_t value_length = [value length];
	ExifContent *exif_content = exif_data->ifd[EXIF_IFD_0];
	ExifEntry *tmp_entry = exif_content_get_entry (exif_content, tag);
	if (tmp_entry == NULL) {
		tmp_entry = exif_entry_new ();
		exif_entry_initialize (tmp_entry, tag);
		exif_content_add_entry (exif_content, tmp_entry);
	}
	char *buf = malloc (sizeof (char) * ([value length] + 1));
	strcpy (buf, [value UTF8String]);
	
	if (tmp_entry->format == EXIF_FORMAT_BYTE) {
		strcpy (tmp_entry->data, buf);
		tmp_entry->data[value_length] = '\0';
	} else if (tmp_entry->format == EXIF_FORMAT_ASCII) {
		strcpy (tmp_entry->data, buf);
		tmp_entry->data[value_length] = '\0';
	} else if (tmp_entry->format == EXIF_FORMAT_SHORT) {
		exif_set_short (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, (ExifShort)(atoi (buf)));
	} else if (tmp_entry->format == EXIF_FORMAT_LONG) {
		exif_set_long (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, (ExifLong)(atol (buf)));
	} else if (tmp_entry->format == EXIF_FORMAT_RATIONAL) {
		float fvalue = atof (buf);
		ExifLong num = (ExifLong)(floor (fvalue * 65535));
		ExifLong den = 65535;
		ExifRational val;
		val.numerator = num;
		val.denominator = den;
		exif_set_rational (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, val);
	} else if (tmp_entry->format == EXIF_FORMAT_SBYTE) {
		tmp_entry->data = (signed char *)buf;
	} else if (tmp_entry->format == EXIF_FORMAT_UNDEFINED) {
		strcpy (tmp_entry->data, buf);
		tmp_entry->data[value_length] = '\0';
	} else if (tmp_entry->format == EXIF_FORMAT_SSHORT) {
		exif_set_sshort (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, (ExifSShort)(atoi (buf)));
	} else if (tmp_entry->format == EXIF_FORMAT_SLONG) {
		exif_set_slong (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, (ExifSLong)(atol (buf)));
	} else if (tmp_entry->format == EXIF_FORMAT_SRATIONAL) {
		float fvalue = atof (buf);
		ExifSLong num = (ExifSLong)(floor (fvalue * 65535));
		ExifSLong den = 65535;
		ExifSRational val;
		val.numerator = num;
		val.denominator = den;
		exif_set_srational (tmp_entry->data, EXIF_BYTE_ORDER_INTEL, val);
	} else if (tmp_entry->format == EXIF_FORMAT_FLOAT) {
		return;
	} else if (tmp_entry->format == EXIF_FORMAT_DOUBLE) {
		return;
	}
	
}

- (void) save {

	JPEGData *jpeg_data = jpeg_data_new ();
	jpeg_data_load_file (jpeg_data, [file UTF8String]);
	jpeg_data_set_exif_data (jpeg_data, exif_data);
	jpeg_data_save_file (jpeg_data, [file UTF8String]);
	jpeg_data_unref (jpeg_data);

}

// super

- (void) dealloc {

	exif_loader_unref (exif_loader);

	[file release];

	[super dealloc];

}

@end


