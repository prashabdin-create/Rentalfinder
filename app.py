import os
import math
import smtplib

from email.message import EmailMessage
from datetime import datetime
from functools import wraps

from dotenv import load_dotenv

from flask import (
    Flask,
    render_template,
    redirect,
    url_for,
    request,
    flash,
    jsonify,
    abort
)

from flask_sqlalchemy import SQLAlchemy

from flask_login import (
    LoginManager,
    UserMixin,
    login_user,
    logout_user,
    login_required,
    current_user
)

from werkzeug.security import (
    generate_password_hash,
    check_password_hash
)

from werkzeug.utils import secure_filename


# =========================================================
# ENVIRONMENT
# =========================================================

load_dotenv()


# =========================================================
# APPLICATION
# =========================================================

app = Flask(__name__)

app.config["SECRET_KEY"] = os.getenv(
    "SECRET_KEY",
    "dev-change-me"
)

app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
    "DATABASE_URL",
    "sqlite:///rental_finder.db"
)

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

app.config["UPLOAD_FOLDER"] = os.path.join(
    app.root_path,
    "static",
    "uploads"
)

app.config["MAX_CONTENT_LENGTH"] = 10 * 1024 * 1024


# =========================================================
# DATABASE
# =========================================================

db = SQLAlchemy(app)


# =========================================================
# LOGIN
# =========================================================

login_manager = LoginManager(app)

login_manager.login_view = "login"

login_manager.login_message = (
    "Please log in to continue."
)


# =========================================================
# FILE SETTINGS
# =========================================================

ALLOWED_EXTENSIONS = {
    "png",
    "jpg",
    "jpeg",
    "webp"
}


# =========================================================
# USER MODEL
# =========================================================

class User(UserMixin, db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    name = db.Column(
        db.String(120),
        nullable=False
    )

    email = db.Column(
        db.String(160),
        unique=True,
        nullable=False,
        index=True
    )

    phone = db.Column(
        db.String(30)
    )

    password_hash = db.Column(
        db.String(255),
        nullable=False
    )

    role = db.Column(
        db.String(20),
        nullable=False,
        index=True
    )

    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )

    # ---------------------------------------------
    # OWNER -> PROPERTIES
    # ---------------------------------------------

    properties = db.relationship(
        "Property",
        backref="owner",
        lazy=True,
        foreign_keys="Property.owner_id"
    )

    # ---------------------------------------------
    # STUDENT -> REQUESTS
    # ---------------------------------------------

    student_requests = db.relationship(
        "Request",
        backref="student",
        lazy=True,
        foreign_keys="Request.student_id"
    )

    # ---------------------------------------------
    # STUDENT -> PREFERENCES
    # ---------------------------------------------

    preferences = db.relationship(
        "StudentPreference",
        backref="student",
        uselist=False,
        cascade="all, delete-orphan",
        lazy=True
    )

    def set_password(self, password):

        self.password_hash = (
            generate_password_hash(password)
        )

    def check_password(self, password):

        return check_password_hash(
            self.password_hash,
            password
        )


# =========================================================
# PROPERTY MODEL
# =========================================================

class Property(db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    owner_id = db.Column(
        db.Integer,
        db.ForeignKey("user.id"),
        nullable=False
    )

    name = db.Column(
        db.String(160),
        nullable=False
    )

    room_type = db.Column(
        db.String(80),
        nullable=False
    )

    rent = db.Column(
        db.Float,
        nullable=False
    )

    deposit = db.Column(
        db.Float,
        default=0
    )

    frequency = db.Column(
        db.String(30),
        default="Monthly"
    )

    available_from = db.Column(
        db.Date,
        nullable=False
    )

    city = db.Column(
        db.String(100),
        nullable=False
    )

    locality = db.Column(
        db.String(160),
        nullable=False
    )

    landmark = db.Column(
        db.String(160)
    )

    distance_college = db.Column(
        db.Float
    )

    address = db.Column(
        db.Text,
        nullable=False
    )

    latitude = db.Column(
        db.Float
    )

    longitude = db.Column(
        db.Float
    )

    description = db.Column(
        db.Text
    )

    amenities = db.Column(
        db.Text,
        default=""
    )

    status = db.Column(
        db.String(20),
        default="pending",
        index=True
    )

    admin_reason = db.Column(
        db.Text
    )

    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )

    # ---------------------------------------------
    # PROPERTY -> PHOTOS
    # ---------------------------------------------

    photos = db.relationship(
        "PropertyPhoto",
        backref="property",
        lazy=True,
        cascade="all, delete-orphan"
    )

    # ---------------------------------------------
    # PROPERTY -> REQUESTS
    # ---------------------------------------------

    requests = db.relationship(
        "Request",
        backref="property",
        lazy=True,
        cascade="all, delete-orphan"
    )


# =========================================================
# PROPERTY PHOTO MODEL
# =========================================================

class PropertyPhoto(db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    property_id = db.Column(
        db.Integer,
        db.ForeignKey("property.id"),
        nullable=False
    )

    filename = db.Column(
        db.String(255),
        nullable=False
    )


# =========================================================
# REQUEST MODEL
# =========================================================

class Request(db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    student_id = db.Column(
        db.Integer,
        db.ForeignKey("user.id"),
        nullable=False
    )

    property_id = db.Column(
        db.Integer,
        db.ForeignKey("property.id"),
        nullable=False
    )

    status = db.Column(
        db.String(20),
        default="pending",
        index=True
    )

    owner_message = db.Column(
        db.Text
    )

    created_at = db.Column(
        db.DateTime,
        default=datetime.utcnow
    )

    decided_at = db.Column(
        db.DateTime
    )


# =========================================================
# STUDENT PREFERENCE MODEL
# =========================================================

class StudentPreference(db.Model):

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    student_id = db.Column(
        db.Integer,
        db.ForeignKey("user.id"),
        nullable=False,
        unique=True
    )

    budget = db.Column(
        db.Float
    )

    room_type = db.Column(
        db.String(80)
    )

    city = db.Column(
        db.String(100)
    )

    locality = db.Column(
        db.String(160)
    )

    latitude = db.Column(
        db.Float
    )

    longitude = db.Column(
        db.Float
    )

    amenities = db.Column(
        db.Text,
        default=""
    )

    updated_at = db.Column(
        db.DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )


# =========================================================
# LOGIN MANAGER
# =========================================================

@login_manager.user_loader
def load_user(user_id):

    return db.session.get(
        User,
        int(user_id)
    )


# =========================================================
# ROLE DECORATOR
# =========================================================

def role_required(role):

    def deco(fn):

        @wraps(fn)
        @login_required
        def wrapped(*args, **kwargs):

            if current_user.role != role:

                flash(
                    "You do not have access to that page.",
                    "error"
                )

                return redirect(
                    url_for("dashboard")
                )

            return fn(
                *args,
                **kwargs
            )

        return wrapped

    return deco


# =========================================================
# HELPERS
# =========================================================

def allowed_file(filename):

    return (
        "."
        in filename
        and
        filename.rsplit(
            ".",
            1
        )[1].lower()
        in ALLOWED_EXTENSIONS
    )


def send_email(
    to,
    subject,
    body
):

    host = os.getenv(
        "SMTP_HOST"
    )

    username = os.getenv(
        "SMTP_USERNAME"
    )

    password = os.getenv(
        "SMTP_PASSWORD"
    )

    sender = os.getenv(
        "SMTP_FROM",
        username
    )

    port = int(
        os.getenv(
            "SMTP_PORT",
            "587"
        )
    )

    if (
        not host
        or not username
        or not password
        or not sender
    ):

        app.logger.warning(
            "SMTP is not configured; email skipped for %s",
            to
        )

        return False

    try:

        msg = EmailMessage()

        msg["Subject"] = subject

        msg["From"] = sender

        msg["To"] = to

        msg.set_content(body)

        with smtplib.SMTP(
            host,
            port,
            timeout=15
        ) as smtp:

            smtp.starttls()

            smtp.login(
                username,
                password
            )

            smtp.send_message(
                msg
            )

        return True

    except Exception as exc:

        app.logger.exception(
            "Email failed: %s",
            exc
        )

        return False


def distance_km(
    lat1,
    lon1,
    lat2,
    lon2
):

    if None in (
        lat1,
        lon1,
        lat2,
        lon2
    ):

        return None

    r = 6371

    p1 = math.radians(
        lat1
    )

    p2 = math.radians(
        lat2
    )

    dp = math.radians(
        lat2 - lat1
    )

    dl = math.radians(
        lon2 - lon1
    )

    a = (
        math.sin(
            dp / 2
        ) ** 2
        +
        math.cos(p1)
        *
        math.cos(p2)
        *
        math.sin(
            dl / 2
        ) ** 2
    )

    return (
        2
        *
        r
        *
        math.asin(
            math.sqrt(a)
        )
    )


def match_score(
    prop,
    prefs
):

    score = 0

    total = 0

    budget = prefs.get(
        "budget"
    )

    room = prefs.get(
        "room_type"
    )

    city = (
        prefs.get(
            "city"
        )
        or ""
    ).strip().lower()

    locality = (
        prefs.get(
            "locality"
        )
        or ""
    ).strip().lower()

    lat = prefs.get(
        "latitude"
    )

    lng = prefs.get(
        "longitude"
    )

    amenities = set(
        prefs.get(
            "amenities",
            []
        )
    )

    prop_amenities = {
        x.strip().lower()
        for x in (
            prop.amenities or ""
        ).split(",")
        if x.strip()
    }


    # BUDGET

    if budget:

        total += 30

        score += (
            30
            if prop.rent <= budget
            else max(
                0,
                30
                -
                min(
                    30,
                    (
                        (
                            prop.rent
                            -
                            budget
                        )
                        /
                        max(
                            budget,
                            1
                        )
                        *
                        30
                    )
                )
            )
        )


    # ROOM TYPE

    if room:

        total += 20

        score += (
            20
            if prop.room_type.lower()
            ==
            room.lower()
            else 0
        )


    # CITY

    if city:

        total += 20

        score += (
            20
            if prop.city.lower()
            ==
            city
            else 0
        )


    # LOCALITY

    if locality:

        total += 10

        score += (
            10
            if locality
            in prop.locality.lower()
            else 0
        )


    # DISTANCE

    if (
        lat is not None
        and
        lng is not None
        and
        prop.latitude is not None
        and
        prop.longitude is not None
    ):

        total += 10

        d = distance_km(
            lat,
            lng,
            prop.latitude,
            prop.longitude
        )

        score += (
            10
            if d <= 2
            else
            7
            if d <= 5
            else
            4
            if d <= 10
            else
            0
        )


    # AMENITIES

    if amenities:

        total += 10

        score += (
            10
            *
            len(
                amenities
                &
                prop_amenities
            )
            /
            len(
                amenities
            )
        )


    return (
        round(
            (
                score
                /
                total
            )
            *
            100
        )
        if total
        else 0
    )


# =========================================================
# GLOBAL VARIABLES
# =========================================================

@app.context_processor
def inject_globals():

    return {
        "now": datetime.utcnow()
    }


# =========================================================
# HOME
# =========================================================

@app.route("/")
def index():

    return render_template(
        "index.html"
    )


# =========================================================
# REGISTER
# =========================================================

@app.route(
    "/register/<role>",
    methods=["GET", "POST"]
)
def register(role):

    if role not in {
        "student",
        "owner"
    }:

        abort(404)


    if request.method == "POST":

        name = request.form[
            "name"
        ].strip()

        email = request.form[
            "email"
        ].strip().lower()

        phone = request.form.get(
            "phone",
            ""
        ).strip()

        password = request.form[
            "password"
        ]


        if User.query.filter_by(
            email=email
        ).first():

            flash(
                "An account with that email already exists.",
                "error"
            )

            return render_template(
                "register.html",
                role=role
            )


        user = User(
            name=name,
            email=email,
            phone=phone,
            role=role
        )

        user.set_password(
            password
        )

        db.session.add(
            user
        )

        db.session.commit()


        flash(
            "Account created. Please log in.",
            "success"
        )

        return redirect(
            url_for(
                "login",
                role=role
            )
        )


    return render_template(
        "register.html",
        role=role
    )


# =========================================================
# LOGIN
# =========================================================

@app.route(
    "/login",
    methods=["GET", "POST"]
)
def login():

    role = request.args.get(
        "role",
        "student"
    )


    if request.method == "POST":

        email = request.form[
            "email"
        ].strip().lower()

        password = request.form[
            "password"
        ]

        user = User.query.filter_by(
            email=email
        ).first()


        if user and user.check_password(
            password
        ):

            login_user(
                user
            )

            return redirect(
                url_for(
                    "dashboard"
                )
            )


        flash(
            "Invalid email or password.",
            "error"
        )


    return render_template(
        "login.html",
        role=role
    )


# =========================================================
# LOGOUT
# =========================================================

@app.route("/logout")
@login_required
def logout():

    logout_user()

    return redirect(
        url_for("index")
    )


# =========================================================
# DASHBOARD REDIRECT
# =========================================================

@app.route("/dashboard")
@login_required
def dashboard():

    if current_user.role == "student":

        return redirect(
            url_for(
                "student_dashboard"
            )
        )

    if current_user.role == "owner":

        return redirect(
            url_for(
                "owner_dashboard"
            )
        )

    return redirect(
        url_for(
            "admin_dashboard"
        )
    )


# =========================================================
# STUDENT DASHBOARD
# =========================================================

@app.route("/student/dashboard")
@role_required("student")
def student_dashboard():

    recent = (
        Request.query
        .filter_by(
            student_id=current_user.id
        )
        .order_by(
            Request.created_at.desc()
        )
        .limit(5)
        .all()
    )

    approved = (
        Property.query
        .filter_by(
            status="approved"
        )
        .order_by(
            Property.created_at.desc()
        )
        .limit(6)
        .all()
    )

    return render_template(
        "student_dashboard.html",
        recent=recent,
        approved=approved
    )


# =========================================================
# STUDENT PREFERENCES
# =========================================================

@app.route(
    "/student/preferences",
    methods=["GET", "POST"]
)
@role_required("student")
def preferences():

    if request.method == "POST":

        budget = (
            float(
                request.form[
                    "budget"
                ]
            )
            if request.form.get(
                "budget"
            )
            else None
        )

        room_type = request.form.get(
            "room_type",
            ""
        ).strip()

        city = request.form.get(
            "city",
            ""
        ).strip()

        locality = request.form.get(
            "locality",
            ""
        ).strip()

        latitude = (
            float(
                request.form[
                    "latitude"
                ]
            )
            if request.form.get(
                "latitude"
            )
            else None
        )

        longitude = (
            float(
                request.form[
                    "longitude"
                ]
            )
            if request.form.get(
                "longitude"
            )
            else None
        )

        amenities = request.form.getlist(
            "amenities"
        )


        # ---------------------------------------------
        # FIND EXISTING PREFERENCES
        # ---------------------------------------------

        saved = (
            StudentPreference.query
            .filter_by(
                student_id=current_user.id
            )
            .first()
        )


        # ---------------------------------------------
        # CREATE IF NEEDED
        # ---------------------------------------------

        if not saved:

            saved = StudentPreference(
                student_id=current_user.id
            )

            db.session.add(
                saved
            )


        # ---------------------------------------------
        # SAVE
        # ---------------------------------------------

        saved.budget = budget

        saved.room_type = room_type

        saved.city = city

        saved.locality = locality

        saved.latitude = latitude

        saved.longitude = longitude

        saved.amenities = ",".join(
            amenities
        )

        db.session.commit()


        # ---------------------------------------------
        # KEEP SEARCH FLOW
        # ---------------------------------------------

        return redirect(
            url_for(
                "properties",
                **{
                    "budget":
                        budget or "",

                    "room_type":
                        room_type,

                    "city":
                        city,

                    "locality":
                        locality,

                    "lat":
                        latitude or "",

                    "lng":
                        longitude or "",

                    "amenities":
                        ",".join(
                            amenities
                        )
                }
            )
        )


    return render_template(
        "preferences.html"
    )


# =========================================================
# STUDENT PROPERTIES
# =========================================================

@app.route("/student/properties")
@role_required("student")
def properties():

    q = Property.query.filter_by(
        status="approved"
    )

    search = request.args.get(
        "q",
        ""
    ).strip()

    city = request.args.get(
        "city",
        ""
    ).strip()

    room = request.args.get(
        "room_type",
        ""
    ).strip()

    locality = request.args.get(
        "locality",
        ""
    ).strip()


    if search:

        term = f"%{search}%"

        q = q.filter(
            db.or_(
                Property.name.ilike(term),
                Property.city.ilike(term),
                Property.locality.ilike(term),
                Property.room_type.ilike(term),
                Property.landmark.ilike(term),
                Property.description.ilike(term),
                Property.amenities.ilike(term)
            )
        )


    if city:

        q = q.filter(
            Property.city.ilike(
                f"%{city}%"
            )
        )


    if room:

        q = q.filter_by(
            room_type=room
        )


    if locality:

        q = q.filter(
            Property.locality.ilike(
                f"%{locality}%"
            )
        )


    props = (
        q
        .order_by(
            Property.created_at.desc()
        )
        .all()
    )


    prefs = {

        "budget":
            float(
                request.args["budget"]
            )
            if request.args.get(
                "budget"
            )
            else None,

        "room_type":
            room,

        "city":
            city,

        "locality":
            locality,

        "latitude":
            float(
                request.args["lat"]
            )
            if request.args.get(
                "lat"
            )
            else None,

        "longitude":
            float(
                request.args["lng"]
            )
            if request.args.get(
                "lng"
            )
            else None,

        "amenities":
            [
                x
                for x in request.args.get(
                    "amenities",
                    ""
                ).split(",")
                if x
            ]
    }


    scored = [
        (
            p,
            match_score(
                p,
                prefs
            )
        )
        for p in props
    ]


    scored.sort(
        key=lambda x: x[1],
        reverse=True
    )


    return render_template(
        "properties.html",
        scored=scored,
        prefs=prefs,
        search=search
    )


# =========================================================
# STUDENT PROPERTY DETAIL
# =========================================================

@app.route(
    "/student/property/<int:property_id>"
)
@role_required("student")
def property_detail(property_id):

    prop = db.session.get(
        Property,
        property_id
    )

    if (
        not prop
        or prop.status != "approved"
    ):

        abort(404)


    existing = (
        Request.query
        .filter_by(
            student_id=current_user.id,
            property_id=property_id
        )
        .first()
    )


    return render_template(
        "property_detail.html",
        prop=prop,
        existing=existing
    )


# =========================================================
# STUDENT SEND REQUEST
# =========================================================

@app.post(
    "/student/property/<int:property_id>/request"
)
@role_required("student")
def send_request(property_id):

    prop = db.session.get(
        Property,
        property_id
    )

    if (
        not prop
        or prop.status != "approved"
    ):

        abort(404)


    existing = (
        Request.query
        .filter_by(
            student_id=current_user.id,
            property_id=property_id
        )
        .first()
    )


    if (
        existing
        and
        existing.status == "pending"
    ):

        flash(
            "You already have a pending request for this property.",
            "info"
        )

        return redirect(
            url_for(
                "property_detail",
                property_id=property_id
            )
        )


    req = Request(
        student_id=current_user.id,
        property_id=property_id
    )

    db.session.add(
        req
    )

    db.session.commit()


    owner = prop.owner


    send_email(
        owner.email,
        f"New Rental Finder request — {prop.name}",
        f"""Hello {owner.name},

{current_user.name} ({current_user.email}) has sent a request for your property "{prop.name}".

Log in to Rental Finder to review the request and accept or reject it.

— Rental Finder"""
    )


    flash(
        "Request sent to the owner.",
        "success"
    )


    return redirect(
        url_for(
            "student_requests"
        )
    )


# =========================================================
# STUDENT REQUESTS
# =========================================================

@app.route("/student/requests")
@role_required("student")
def student_requests():

    reqs = (
        Request.query
        .filter_by(
            student_id=current_user.id
        )
        .order_by(
            Request.created_at.desc()
        )
        .all()
    )

    return render_template(
        "student_requests.html",
        requests=reqs
    )


# =========================================================
# STUDENT REQUEST DETAIL
# =========================================================

@app.route(
    "/student/request/<int:req_id>"
)
@role_required("student")
def student_request_detail(req_id):

    req = db.session.get(
        Request,
        req_id
    )

    if (
        not req
        or req.student_id != current_user.id
    ):

        abort(404)


    return render_template(
        "student_request_detail.html",
        req=req
    )


# =========================================================
# OWNER DASHBOARD
# =========================================================

@app.route("/owner/dashboard")
@role_required("owner")
def owner_dashboard():

    props = (
        Property.query
        .filter_by(
            owner_id=current_user.id
        )
        .order_by(
            Property.created_at.desc()
        )
        .all()
    )

    incoming = (
        Request.query
        .join(Property)
        .filter(
            Property.owner_id
            ==
            current_user.id
        )
        .order_by(
            Request.created_at.desc()
        )
        .limit(6)
        .all()
    )

    return render_template(
        "owner_dashboard.html",
        properties=props,
        requests=incoming
    )


# =========================================================
# OWNER ADD PROPERTY
# =========================================================

@app.route(
    "/owner/property/add",
    methods=["GET", "POST"]
)
@role_required("owner")
def add_property():

    if request.method == "POST":

        try:

            prop = Property(

                owner_id=current_user.id,

                name=request.form[
                    "name"
                ].strip(),

                room_type=request.form[
                    "room_type"
                ],

                rent=float(
                    request.form[
                        "rent"
                    ]
                ),

                deposit=float(
                    request.form.get(
                        "deposit"
                    )
                    or 0
                ),

                frequency=request.form[
                    "frequency"
                ],

                available_from=datetime.strptime(
                    request.form[
                        "available_from"
                    ],
                    "%Y-%m-%d"
                ).date(),

                city=request.form[
                    "city"
                ].strip(),

                locality=request.form[
                    "locality"
                ].strip(),

                landmark=request.form.get(
                    "landmark",
                    ""
                ).strip(),

                distance_college=(
                    float(
                        request.form[
                            "distance_college"
                        ]
                    )
                    if request.form.get(
                        "distance_college"
                    )
                    else None
                ),

                address=request.form[
                    "address"
                ].strip(),

                latitude=(
                    float(
                        request.form[
                            "latitude"
                        ]
                    )
                    if request.form.get(
                        "latitude"
                    )
                    else None
                ),

                longitude=(
                    float(
                        request.form[
                            "longitude"
                        ]
                    )
                    if request.form.get(
                        "longitude"
                    )
                    else None
                ),

                description=request.form.get(
                    "description",
                    ""
                ).strip(),

                amenities=",".join(
                    request.form.getlist(
                        "amenities"
                    )
                ),

                status="pending"
            )


            db.session.add(
                prop
            )

            db.session.flush()


            for file in request.files.getlist(
                "photos"
            ):

                if (
                    file
                    and file.filename
                    and allowed_file(
                        file.filename
                    )
                ):

                    filename = (
                        f"{prop.id}_"
                        f"{datetime.utcnow().strftime('%Y%m%d%H%M%S%f')}_"
                        f"{secure_filename(file.filename)}"
                    )


                    file.save(
                        os.path.join(
                            app.config[
                                "UPLOAD_FOLDER"
                            ],
                            filename
                        )
                    )


                    db.session.add(
                        PropertyPhoto(
                            property_id=prop.id,
                            filename=filename
                        )
                    )


            db.session.commit()


            flash(
                "Property submitted for admin approval.",
                "success"
            )


            return redirect(
                url_for(
                    "owner_properties"
                )
            )


        except Exception as exc:

            db.session.rollback()

            app.logger.exception(
                exc
            )

            flash(
                "Could not save the property. Please check the form.",
                "error"
            )


    return render_template(
        "add_property.html"
    )


# =========================================================
# OWNER PROPERTIES
# =========================================================

@app.route("/owner/properties")
@role_required("owner")
def owner_properties():

    props = (
        Property.query
        .filter_by(
            owner_id=current_user.id
        )
        .order_by(
            Property.created_at.desc()
        )
        .all()
    )

    return render_template(
        "owner_properties.html",
        properties=props
    )


# =========================================================
# OWNER EDIT PROPERTY
# =========================================================

@app.route(
    "/owner/property/<int:property_id>/edit",
    methods=["GET", "POST"]
)
@role_required("owner")
def edit_property(property_id):

    prop = (
        Property.query
        .filter_by(
            id=property_id,
            owner_id=current_user.id
        )
        .first_or_404()
    )


    if request.method == "POST":

        try:

            prop.name = request.form[
                "name"
            ].strip()

            prop.room_type = request.form[
                "room_type"
            ]

            prop.rent = float(
                request.form[
                    "rent"
                ]
            )

            prop.deposit = float(
                request.form.get(
                    "deposit"
                )
                or 0
            )

            prop.frequency = request.form[
                "frequency"
            ]

            prop.available_from = (
                datetime.strptime(
                    request.form[
                        "available_from"
                    ],
                    "%Y-%m-%d"
                ).date()
            )

            prop.city = request.form[
                "city"
            ].strip()

            prop.locality = request.form[
                "locality"
            ].strip()

            prop.landmark = request.form.get(
                "landmark",
                ""
            ).strip()

            prop.distance_college = (
                float(
                    request.form[
                        "distance_college"
                    ]
                )
                if request.form.get(
                    "distance_college"
                )
                else None
            )

            prop.address = request.form[
                "address"
            ].strip()

            prop.latitude = (
                float(
                    request.form[
                        "latitude"
                    ]
                )
                if request.form.get(
                    "latitude"
                )
                else None
            )

            prop.longitude = (
                float(
                    request.form[
                        "longitude"
                    ]
                )
                if request.form.get(
                    "longitude"
                )
                else None
            )

            prop.description = request.form.get(
                "description",
                ""
            ).strip()

            prop.amenities = ",".join(
                request.form.getlist(
                    "amenities"
                )
            )


            # Edited properties require
            # another admin review.

            prop.status = "pending"

            prop.admin_reason = ""


            # Add new photos if supplied.

            for file in request.files.getlist(
                "photos"
            ):

                if (
                    file
                    and file.filename
                    and allowed_file(
                        file.filename
                    )
                ):

                    filename = (
                        f"{prop.id}_"
                        f"{datetime.utcnow().strftime('%Y%m%d%H%M%S%f')}_"
                        f"{secure_filename(file.filename)}"
                    )


                    file.save(
                        os.path.join(
                            app.config[
                                "UPLOAD_FOLDER"
                            ],
                            filename
                        )
                    )


                    db.session.add(
                        PropertyPhoto(
                            property_id=prop.id,
                            filename=filename
                        )
                    )


            db.session.commit()


            flash(
                "Property updated and sent for admin approval again.",
                "success"
            )


            return redirect(
                url_for(
                    "owner_properties"
                )
            )


        except Exception as exc:

            db.session.rollback()

            app.logger.exception(
                exc
            )

            flash(
                "Could not update the property. Please check the form.",
                "error"
            )


    return render_template(
        "owner_edit_property.html",
        prop=prop
    )


# =========================================================
# OWNER DELETE PROPERTY
# =========================================================

@app.post(
    "/owner/property/<int:property_id>/delete"
)
@role_required("owner")
def delete_property(property_id):

    prop = (
        Property.query
        .filter_by(
            id=property_id,
            owner_id=current_user.id
        )
        .first_or_404()
    )


    try:

        photo_files = [
            photo.filename
            for photo in prop.photos
        ]


        db.session.delete(
            prop
        )

        db.session.commit()


        for filename in photo_files:

            filepath = os.path.join(
                app.config[
                    "UPLOAD_FOLDER"
                ],
                filename
            )


            try:

                if os.path.exists(
                    filepath
                ):

                    os.remove(
                        filepath
                    )

            except OSError:

                app.logger.warning(
                    "Could not remove image file: %s",
                    filepath
                )


        flash(
            "Property deleted successfully.",
            "success"
        )


    except Exception as exc:

        db.session.rollback()

        app.logger.exception(
            exc
        )

        flash(
            "Could not delete the property.",
            "error"
        )


    return redirect(
        url_for(
            "owner_properties"
        )
    )


# =========================================================
# OWNER REQUESTS
# =========================================================

@app.route("/owner/requests")
@role_required("owner")
def owner_requests():

    reqs = (
        Request.query
        .join(Property)
        .filter(
            Property.owner_id
            ==
            current_user.id
        )
        .order_by(
            Request.created_at.desc()
        )
        .all()
    )

    return render_template(
        "owner_requests.html",
        requests=reqs
    )


# =========================================================
# OWNER REQUEST DETAIL
# =========================================================

@app.route(
    "/owner/request/<int:req_id>"
)
@role_required("owner")
def owner_request_detail(req_id):

    req = db.session.get(
        Request,
        req_id
    )


    if (
        not req
        or req.property.owner_id
        != current_user.id
    ):

        abort(404)


    return render_template(
        "owner_request_detail.html",
        req=req
    )


# =========================================================
# OWNER ACCEPT / REJECT REQUEST
# =========================================================

@app.post(
    "/owner/request/<int:req_id>/<decision>"
)
@role_required("owner")
def owner_decide(
    req_id,
    decision
):

    if decision not in {
        "accepted",
        "rejected"
    }:

        abort(400)


    req = db.session.get(
        Request,
        req_id
    )


    if (
        not req
        or req.property.owner_id
        != current_user.id
    ):

        abort(404)


    if req.status != "pending":

        flash(
            "This request has already been decided.",
            "info"
        )

        return redirect(
            url_for(
                "owner_request_detail",
                req_id=req_id
            )
        )


    req.status = decision

    req.owner_message = request.form.get(
        "message",
        ""
    ).strip()

    req.decided_at = datetime.utcnow()

    db.session.commit()


    student = req.student


    if decision == "accepted":

        subject = (
            f"Request accepted — "
            f"{req.property.name}"
        )

        body = f"""Hello {student.name},

Good news! The owner has accepted your request for "{req.property.name}".

You can now log in to Rental Finder to see the owner's contact details.

— Rental Finder"""


    else:

        subject = (
            f"Request update — "
            f"{req.property.name}"
        )

        body = f"""Hello {student.name},

The owner has rejected your request for "{req.property.name}".

Owner message: {req.owner_message or "No additional message was provided."}

— Rental Finder"""


    send_email(
        student.email,
        subject,
        body
    )


    flash(
        f"Request {decision}. The student has been notified by email.",
        "success"
    )


    return redirect(
        url_for(
            "owner_requests"
        )
    )


# =========================================================
# ADMIN LOGIN
# =========================================================

@app.route(
    "/admin/login",
    methods=["GET", "POST"]
)
def admin_login():

    if request.method == "POST":

        email = request.form[
            "email"
        ].strip().lower()

        password = request.form[
            "password"
        ]


        user = (
            User.query
            .filter_by(
                email=email,
                role="admin"
            )
            .first()
        )


        if (
            user
            and
            user.check_password(
                password
            )
        ):

            login_user(
                user
            )

            return redirect(
                url_for(
                    "admin_dashboard"
                )
            )


        flash(
            "Invalid admin credentials.",
            "error"
        )


    return render_template(
        "admin_login.html"
    )


# =========================================================
# ADMIN DASHBOARD
# =========================================================

@app.route("/admin/dashboard")
@role_required("admin")
def admin_dashboard():

    stats = {

        "students":
            User.query
            .filter_by(
                role="student"
            )
            .count(),

        "owners":
            User.query
            .filter_by(
                role="owner"
            )
            .count(),

        "properties":
            Property.query.count(),

        "pending_properties":
            Property.query
            .filter_by(
                status="pending"
            )
            .count(),

        "requests":
            Request.query.count()
    }


    pending = (
        Property.query
        .filter_by(
            status="pending"
        )
        .order_by(
            Property.created_at.desc()
        )
        .limit(8)
        .all()
    )


    return render_template(
        "admin_dashboard.html",
        stats=stats,
        pending=pending
    )


# =========================================================
# ADMIN PROPERTIES
# =========================================================

@app.route("/admin/properties")
@role_required("admin")
def admin_properties():

    properties = (
        Property.query
        .order_by(
            Property.created_at.desc()
        )
        .all()
    )


    return render_template(
        "admin_properties.html",
        properties=properties
    )


# =========================================================
# ADMIN PROPERTY DETAIL
# =========================================================

@app.route(
    "/admin/property/<int:property_id>"
)
@role_required("admin")
def admin_property_detail(property_id):

    prop = db.session.get(
        Property,
        property_id
    )


    if not prop:

        abort(404)


    return render_template(
        "admin_property_detail.html",
        prop=prop
    )


# =========================================================
# ADMIN PROPERTY APPROVE / REJECT
# =========================================================

@app.post(
    "/admin/property/<int:property_id>/<decision>"
)
@role_required("admin")
def admin_property_decision(
    property_id,
    decision
):

    if decision not in {
        "approved",
        "rejected"
    }:

        abort(400)


    prop = db.session.get(
        Property,
        property_id
    )


    if not prop:

        abort(404)


    prop.status = decision


    if decision == "rejected":

        prop.admin_reason = (
            request.form.get(
                "reason",
                ""
            ).strip()
        )

    else:

        prop.admin_reason = ""


    db.session.commit()


    if decision == "approved":

        subject = (
            f"Property approved — "
            f"{prop.name}"
        )

        body = f"""Hello {prop.owner.name},

Your property "{prop.name}" has been approved and is now visible to students.

— Rental Finder"""


    else:

        subject = (
            f"Property needs changes — "
            f"{prop.name}"
        )

        body = f"""Hello {prop.owner.name},

Your property "{prop.name}" was not approved.

Admin reason: {prop.admin_reason or "No reason provided."}

Please update the listing and submit it again if needed.

— Rental Finder"""


    send_email(
        prop.owner.email,
        subject,
        body
    )


    flash(
        f"Property {decision}. Owner notification sent.",
        "success"
    )


    return redirect(
        url_for(
            "admin_properties"
        )
    )


# =========================================================
# ADMIN REQUESTS
# =========================================================

@app.route("/admin/requests")
@role_required("admin")
def admin_requests():

    requests = (
        Request.query
        .order_by(
            Request.created_at.desc()
        )
        .all()
    )


    return render_template(
        "admin_requests.html",
        requests=requests
    )


# =========================================================
# ADMIN USERS
# =========================================================

@app.route("/admin/users")
@role_required("admin")
def admin_users():

    students = (
        User.query
        .filter_by(
            role="student"
        )
        .order_by(
            User.created_at.desc()
        )
        .all()
    )


    owners = (
        User.query
        .filter_by(
            role="owner"
        )
        .order_by(
            User.created_at.desc()
        )
        .all()
    )


    return render_template(
        "admin_users.html",
        students=students,
        owners=owners
    )


# =========================================================
# ADMIN USER DETAIL
# =========================================================

@app.route(
    "/admin/user/<int:user_id>"
)
@role_required("admin")
def admin_user_detail(user_id):

    user = db.session.get(
        User,
        user_id
    )


    # Admin accounts are not managed
    # through this screen.

    if (
        not user
        or user.role == "admin"
    ):

        abort(404)


    # =====================================================
    # STUDENT DETAILS
    # =====================================================

    if user.role == "student":

        requirements = (
            StudentPreference.query
            .filter_by(
                student_id=user.id
            )
            .first()
        )


        requests = (
            Request.query
            .filter_by(
                student_id=user.id
            )
            .order_by(
                Request.created_at.desc()
            )
            .all()
        )


        return render_template(
            "admin_user_detail.html",
            user=user,
            requirements=requirements,
            requests=requests,
            properties=None
        )


    # =====================================================
    # OWNER DETAILS
    # =====================================================

    properties = (
        Property.query
        .filter_by(
            owner_id=user.id
        )
        .order_by(
            Property.created_at.desc()
        )
        .all()
    )


    return render_template(
        "admin_user_detail.html",
        user=user,
        requirements=None,
        requests=None,
        properties=properties
    )


# =========================================================
# ADMIN DELETE USER
# =========================================================

@app.post(
    "/admin/user/<int:user_id>/delete"
)
@role_required("admin")
def admin_delete_user(user_id):

    user = db.session.get(
        User,
        user_id
    )


    if not user:

        abort(404)


    # Never delete admin from this interface.

    if user.role == "admin":

        flash(
            "Admin accounts cannot be deleted here.",
            "error"
        )

        return redirect(
            url_for(
                "admin_users"
            )
        )


    try:

        # =================================================
        # DELETE STUDENT DATA
        # =================================================

        if user.role == "student":

            # Remove all student requests.
            student_requests = (
                Request.query
                .filter_by(
                    student_id=user.id
                )
                .all()
            )

            for req in student_requests:

                db.session.delete(
                    req
                )


            # Remove saved preferences.
            student_preferences = (
                StudentPreference.query
                .filter_by(
                    student_id=user.id
                )
                .first()
            )


            if student_preferences:

                db.session.delete(
                    student_preferences
                )


        # =================================================
        # DELETE OWNER DATA
        # =================================================

        elif user.role == "owner":

            owner_properties = (
                Property.query
                .filter_by(
                    owner_id=user.id
                )
                .all()
            )


            for prop in owner_properties:

                # Remember uploaded photo files.
                photo_files = [
                    photo.filename
                    for photo in prop.photos
                ]


                # Deleting the property also
                # deletes its photos/requests
                # from the database because of
                # the configured cascade.

                db.session.delete(
                    prop
                )


                # Remove uploaded files.
                for filename in photo_files:

                    filepath = os.path.join(
                        app.config[
                            "UPLOAD_FOLDER"
                        ],
                        filename
                    )


                    try:

                        if os.path.exists(
                            filepath
                        ):

                            os.remove(
                                filepath
                            )

                    except OSError:

                        app.logger.warning(
                            "Could not remove owner image: %s",
                            filepath
                        )


        # =================================================
        # DELETE USER
        # =================================================

        db.session.delete(
            user
        )

        db.session.commit()


        flash(
            "User and associated data deleted successfully.",
            "success"
        )


    except Exception as exc:

        db.session.rollback()

        app.logger.exception(
            exc
        )

        flash(
            "Could not delete this user.",
            "error"
        )


    return redirect(
        url_for(
            "admin_users"
        )
    )


# =========================================================
# DATABASE INITIALIZATION
# =========================================================

with app.app_context():

    os.makedirs(
        app.config[
            "UPLOAD_FOLDER"
        ],
        exist_ok=True
    )


    db.create_all()


    admin_email = os.getenv(
        "ADMIN_EMAIL",
        "admin@rentalfinder.com"
    ).lower()


    admin = User.query.filter_by(
        email=admin_email
    ).first()


    if not admin:

        admin = User(

            name=os.getenv(
                "ADMIN_NAME",
                "Rental Finder Admin"
            ),

            email=admin_email,

            role="admin"
        )


        admin.set_password(
            os.getenv(
                "ADMIN_PASSWORD",
                "change-this-password"
            )
        )


        db.session.add(
            admin
        )

        db.session.commit()


# =========================================================
# RUN
# =========================================================

if __name__ == "__main__":

    app.run(
        debug=True
    )