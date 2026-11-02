from ipo_analyser.rendering import area_path, day, moment, segment_label, smooth_path, tone


def test_day_formats_iso_dates_and_axis_labels():
    assert day("2026-08-07") == "7 Aug"
    assert day("2026-08-07", year=True) == "7 Aug 2026"
    assert day("2026-08-07T12:30:00+00:00") == "7 Aug"
    assert day("08-04") == "4 Aug"
    assert day(None) == "—"


def test_moment_shows_india_time():
    assert moment("2026-08-10T10:35:00+00:00") == "10 Aug, 16:05 IST"
    assert moment(None) == "—"


def test_segment_label_and_tone():
    assert segment_label("sme") == "SME"
    assert segment_label("mainboard") == "Mainboard"
    assert segment_label("unknown") == "Segment unknown"
    assert [tone(s) for s in ("strong", "positive", "neutral", "weak")] == [
        "up",
        "up",
        "mid",
        "down",
    ]


def test_smooth_path_passes_through_every_point():
    points = [{"x": 0, "y": 100}, {"x": 50, "y": 20}, {"x": 100, "y": 60}, {"x": 150, "y": 60}]
    path = smooth_path(points)
    assert path.startswith("M 0.0 100.0")
    for point in points[1:]:
        assert f"{point['x']:.1f} {point['y']:.1f}" in path
    # A local peak gets a flat tangent, so the curve never overshoots the data.
    assert "C 16.7 73.3, 33.3 20.0, 50.0 20.0" in path


def test_sparse_series_get_no_curve_or_area():
    assert smooth_path([]) == ""
    assert smooth_path([{"x": 10, "y": 5}]) == "M 10.0 5.0"
    assert area_path([{"x": 10, "y": 5}, {"x": 20, "y": 6}]) == ""
    area = area_path([{"x": 0, "y": 5}, {"x": 10, "y": 6}, {"x": 20, "y": 7}])
    assert area.endswith("L 20.0 218.0 L 0.0 218.0 Z")
