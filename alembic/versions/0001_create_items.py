"""create items table

Revision ID: 0001_create_items
Revises: 
Create Date: 2025-06-26 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa

def upgrade():
    op.create_table(
        'items',
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('name', sa.String, nullable=False),
        sa.Column('description', sa.String, nullable=False),
    )

def downgrade():
    op.drop_table('items')
