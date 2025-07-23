# FastAPI JINJA2 Project



## Project Structure

```plaintext
fastapi-jinja2-project/
├── app/                          # Core application directory
│   ├── __init__.py              # Marks app as a Python package
│   ├── main.py                  # FastAPI application entry point
│   ├── core/                    # Core configurations and utilities
│   │   ├── config.py            # Environment variables and settings
│   │   ├── security.py          # Authentication and security utilities
│   │   └── dependencies.py      # Dependency injection logic
│   ├── routes/                  # API routes and view endpoints
│   │   ├── __init__.py
│   │   ├── api/                 # API-specific routes (RESTful endpoints)
│   │   │   ├── __init__.py
│   │   │   ├── users.py         # User-related API endpoints
│   │   │   └── items.py         # Item-related API endpoints
│   │   └── views/               # Jinja2 template rendering routes
│   │       ├── __init__.py
│   │       ├── home.py          # Home page view
│   │       └── dashboard.py     # Dashboard view
│   ├── models/                  # Database models (e.g., SQLAlchemy)
│   │   ├── __init__.py
│   │   ├── user.py              # User database model
│   │   └── item.py              # Item database model
│   ├── schemas/                 # Pydantic schemas for validation
│   │   ├── __init__.py
│   │   ├── user.py              # User-related schemas
│   │   └── item.py              # Item-related schemas
│   ├── templates/               # Jinja2 HTML templates
│   │   ├── base/                # Base templates for inheritance
│   │   │   ├── base.html        # Main base template
│   │   │   └── layout.html      # Common layout components
│   │   ├── components/          # Reusable template components
│   │   │   ├── navbar.html      # Navigation bar
│   │   │   ├── footer.html      # Footer
│   │   │   └── forms/           # Form templates
│   │   ├── macros/              # Jinja2 macros for reusable logic
│   │   │   ├── forms.html       # Form rendering macros
│   │   │   └── utils.html       # Utility macros
│   │   └── pages/               # Page-specific templates
│   │       ├── home.html        # Home page template
│   │       ├── dashboard.html   # Dashboard template
│   │       └── profile.html     # User profile template
│   ├── static/                  # Static files (CSS, JS, images)
│   │   ├── css/                 # CSS files
│   │   │   └── main.css
│   │   ├── js/                  # JavaScript files
│   │   │   └── main.js
│   │   └── img/                 # Images
│   ├── services/                # Business logic and service layer
│   │   ├── __init__.py
│   │   ├── user_service.py      # User-related business logic
│   │   └── item_service.py      # Item-related business logic
│   └── utils/                   # Utility functions
│       ├── __init__.py
│       ├── logging.py           # Custom logging setup
│       └── helpers.py           # Miscellaneous helper functions
├── tests/                       # Test suite
│   ├── __init__.py
│   ├── test_api/                # Tests for API endpoints
│   │   ├── test_users.py
│   │   └── test_items.py
│   └── test_views/              # Tests for view endpoints
│       ├── test_home.py
│       └── test_dashboard.py
├── alembic/                     # Database migrations (if using SQLAlchemy)
│   ├── env.py
│   └── versions/                # Migration scripts
├── .env                         # Environment variables
├── .gitignore                   # Git ignore file
├── requirements.txt             # Project dependencies
├── Dockerfile                   # Docker configuration
├── docker-compose.yml           # Docker Compose for local development
└── README.md                    # Project documentation
```

## Explanation of Structure

1. `app/:` The core application directory, containing all Python code and templates.
    - `main.py:` The entry point for the FastAPI application, where the app is initialized and routers are included.
    - `core/:` Stores configuration, security, and dependency injection logic.
        - `config.py:` Manages environment variables (e.g., using `python-dotenv` or `pydantic-settings`).
        - `security.py:` Handles authentication (e.g., JWT, OAuth2).
        - `dependencies.py:` Defines reusable dependencies for routes.
    - `routes/:` Separates API endpoints (`api/`) and template-rendering views (`views/`).
        - `api/:` RESTful endpoints for JSON responses (e.g., `/api/users`, `/api/items`).
        - `views/:` Endpoints that render Jinja2 templates (e.g., `/home`, `/dashboard`).
    - `models/:` Database models, typically using SQLAlchemy or SQLModel for ORM.
    - `schemas/:` Pydantic models for request/response validation.
    - `templates/:` Jinja2 templates, organized for maintainability.
        - `base/:` Base templates for inheritance to ensure consistent layouts.
        - `components/:` Reusable UI components (e.g., navbar, footer).
        - `macros/:` Jinja2 macros for reusable template logic.
        - `pages/:` Page-specific templates.
    - `static/:` Static assets like CSS, JavaScript, and images, served via `StaticFiles`.
    - `services/:` Business logic to keep routes lean and maintain separation of concerns.
    - `utils/:` Miscellaneous utilities (e.g., logging, helper functions).

2. `tests/:` Test suite for API and view endpoints, ensuring code quality.
3. `alembic/:` Database migration scripts for schema changes (if using SQLAlchemy).
4. `.env:` Stores environment variables (e.g., `database URLs`, `secret keys`).
5. `requirements.txt:` Lists dependencies (e.g., `fastapi`, `jinja2`, `uvicorn`).
6. `Dockerfile and docker-compose.yml:` Facilitates containerized development and deployment.

## Example Code Snippets
==app/main.py==

```python
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pathlib import Path
from app.routes.api import users, items
from app.routes.views import home, dashboard

app = FastAPI(title="FastAPI Jinja2 App", version="1.0.0")

# Mount static files
app.mount("/static", StaticFiles(directory=Path(__file__).parent / "static"), name="static")

# Setup Jinja2 templates
templates = Jinja2Templates(directory=Path(__file__).parent / "templates")

# Include routers
app.include_router(users.router, prefix="/api")
app.include_router(items.router, prefix="/api")
app.include_router(home.router)
app.include_router(dashboard.router)
```

==app/templates/base/base.html==
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}{{ title }}{% endblock %} - MyApp</title>
    <link rel="stylesheet" href="{{ url_for('static', path='/css/main.css') }}">
    {% block extra_css %}{% endblock %}
</head>
<body>
    {% include "components/navbar.html" %}
    {% block content_wrapper %}
        <main>
            {% block content %}{% endblock %}
        </main>
    {% endblock %}
    {% include "components/footer.html" %}
    <script src="{{ url_for('static', path='/js/main.js') }}"></script>
    {% block extra_js %}{% endblock %}
</body>
</html>
```

==app/routes/views/home.py==
```python
from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates
from pathlib import Path

router = APIRouter()
templates = Jinja2Templates(directory=Path(__file__).resolve().parent.parent.parent / "templates")

@router.get("/", response_class=HTMLResponse)
async def home(request: Request):
    return templates.TemplateResponse("pages/home.html", {"request": request, "title": "Home"})
```

## Sources

This structure draws inspiration from:
    - FastAPI official documentation on templates and bigger applications. (advanced/templates)[https://fastapi.tiangolo.com/advanced/templates/] (tutorial/bigger-applications)[https://fastapi.tiangolo.com/tutorial/bigger-applications/]
    - Community best practices from GitHub repositories like `zhanymkanov/fastapi-best-practices`. (zhanymkanov/fastapi-best-practices)[https://github.com/zhanymkanov/fastapi-best-practices]
    - Advanced Jinja2 patterns from getlazy.ai.
    - Real-world project structures from Medium and other tutorials. (https://medium.com)[https://medium.com/%40amirm.lavasani/how-to-structure-your-fastapi-projects-0219a6600a8f] (https://medium.com)[https://medium.com/django-unleashed/how-to-build-dynamic-frontends-with-fastapi-and-jinja2-e0a89879aaed]
